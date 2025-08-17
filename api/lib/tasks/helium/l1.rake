# typed: false

#
# Rake tasks for importing Helium L1 accounts from S3
#
# The accounts are stored in the foundation-helium-l1-archive-requester-pays bucket
# and must be accessed with requester-pays enabled.
#
# Available tasks:
# - helium:l1:list_files - List all available files in S3
# - helium:l1:import_accounts - Import all account files from S3
# - helium:l1:import_specific_file[s3_key] - Import a specific file by S3 key
#
# Usage examples:
#   rake helium:l1:list_files
#   rake helium:l1:import_accounts
#   rake helium:l1:import_specific_file[blockchain-etl-export/accounts/data_xaa.csv.gz]

namespace :helium do
  namespace :l1 do
    desc "Import Helium L1 accounts from S3 bucket"
    task import_accounts: :environment do
      bucket_name = "foundation-helium-l1-archive-requester-pays"
      prefix = "blockchain-etl-export/account_inventory/"

      puts "Starting import of Helium L1 accounts from S3..."
      puts "Bucket: #{bucket_name}"
      puts "Prefix: #{prefix}"

      begin
        import_l1_accounts(bucket_name, prefix)
        puts "Import completed successfully!"
      rescue StandardError => e
        puts "Error during import: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end

    desc "List all available L1 accounts files in S3"
    task list_files: :environment do
      bucket_name = "foundation-helium-l1-archive-requester-pays"
      prefix = "blockchain-etl-export/account_inventory/"

      puts "Listing L1 accounts files in S3..."
      puts "Bucket: #{bucket_name}"
      puts "Prefix: #{prefix}"
      puts

      begin
        list_s3_files(bucket_name, prefix)
      rescue StandardError => e
        puts "Error listing files: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end

    desc "Import a specific L1 accounts file from S3"
    task :import_file, [ :s3_key ] => :environment do |_t, args|
      s3_key = args[:s3_key]

      if s3_key.blank?
        puts "Error: S3 key is required"
        puts "Usage: rake helium:l1:import_file[s3_key]"
        exit 1
      end

      bucket_name = "foundation-helium-l1-archive-requester-pays"

      puts "Importing specific file: #{s3_key}"
      puts "Bucket: #{bucket_name}"

      begin
        process_accounts_file(bucket_name, s3_key)
        puts "File import completed successfully!"
      rescue StandardError => e
        puts "Error during import: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end

    private

    define_method(:import_l1_accounts) do |bucket_name, prefix|
      file_client = create_s3_client
      file_count = 0
      total_files = 0

      puts "Listing files in S3 bucket..."

      # First, count total files
      file_client.each_object(
        bucket: bucket_name,
        prefix: prefix
      ) do |object|
        total_files += 1 if object.key.end_with?(".csv.gz")
      end

      puts "Found #{total_files} files to process"

      # Now process each file
      file_client.each_object(
        bucket: bucket_name,
        prefix: prefix
      ) do |object|
        next unless object.key.end_with?(".csv.gz")

        file_count += 1
        puts "Processing file #{file_count}/#{total_files}: #{object.key}"

        begin
          process_accounts_file(bucket_name, object.key)
          puts "✓ Completed file #{file_count}/#{total_files}"
        rescue StandardError => e
          puts "✗ Error processing file #{file_count}/#{total_files}: #{e.message}"
          raise e
        end
      end

      puts "Processed #{file_count} files total"
    end

    define_method(:process_accounts_file) do |bucket_name, s3_key|
      file_client = create_s3_client

      csv_file = download_and_decompress(file_client, bucket_name, s3_key)
      begin
        import_accounts_from_csv(csv_file)
      ensure
        # Clean up the decompressed temp file
        csv_file.close
        csv_file.unlink
      end
    end

    define_method(:download_and_decompress) do |file_client, bucket_name, s3_key|
      require "zlib"
      require "tempfile"

      temp_file = Tempfile.new([ "l1_accounts", ".csv" ])
      temp_file.binmode

      puts "Downloading #{s3_key}..."

      file_client.get_object(
        bucket: bucket_name,
        key: s3_key,
        response_target: temp_file.path
      )

      puts "Decompressing file..."

      # Create a new tempfile that won't be automatically closed
      decompressed_file = Tempfile.new([ "l1_accounts_decompressed", ".csv" ])
      decompressed_file.binmode

      Zlib::GzipReader.open(temp_file.path) do |gz|
        decompressed_file.write(gz.read)
      end

      # Clean up the original compressed temp file
      temp_file.close
      temp_file.unlink

      decompressed_file.rewind
      decompressed_file
    end

    define_method(:import_accounts_from_csv) do |csv_file|
      require "csv"

      batch_size = 5000  # Increased batch size for better performance
      batch = []
      total_imported = 0
      line_count = 0

      puts "Importing accounts from CSV..."

      # Check if the file has headers by examining the first row
      has_headers = false
      File.open(csv_file.path, "r") do |file|
        first_line = file.gets
        if first_line
          first_row = CSV.parse_line(first_line)
          # Check if the first column (address) looks like a header
          has_headers = first_row && first_row[0] == "address"
        end
      end

      puts "Headers detected: #{has_headers}"

      CSV.foreach(csv_file.path, headers: has_headers) do |row|
        line_count += 1

        # Skip header row if headers were detected
        next if has_headers && line_count == 1

        account_data = parse_account_row(row)
        batch << account_data

        if batch.size >= batch_size
          import_batch(batch)
          total_imported += batch.size
          puts "Imported #{total_imported} accounts so far..."
          batch = []

          # Force garbage collection to free memory
          GC.start if line_count % 10000 == 0
        end
      end

      # Import remaining records
      if batch.any?
        import_batch(batch)
        total_imported += batch.size
      end

      puts "Total accounts imported: #{total_imported}"
    end

    define_method(:parse_account_row) do |row|
      # Column order: address,balance,nonce,dc_balance,dc_nonce,security_balance,security_nonce,first_block,last_block,staked_balance,mobile_balance,iot_balance
      if row.header_row?
        # Use header names when headers are present
        {
          address: row["address"],
          balance: row["balance"].to_i,
          nonce: row["nonce"].to_i,
          dc_balance: row["dc_balance"].to_i,
          dc_nonce: row["dc_nonce"].to_i,
          security_balance: row["security_balance"].to_i,
          security_nonce: row["security_nonce"].to_i,
          first_block: row["first_block"].to_i,
          last_block: row["last_block"].to_i,
          staked_balance: row["staked_balance"].to_i,
          mobile_balance: row["mobile_balance"].to_i,
          iot_balance: row["iot_balance"].to_i
        }
      else
        # Use column positions when no headers
        {
          address: row[0],
          balance: row[1].to_i,
          nonce: row[2].to_i,
          dc_balance: row[3].to_i,
          dc_nonce: row[4].to_i,
          security_balance: row[5].to_i,
          security_nonce: row[6].to_i,
          first_block: row[7].to_i,
          last_block: row[8].to_i,
          staked_balance: row[9].to_i,
          mobile_balance: row[10].to_i,
          iot_balance: row[11].to_i
        }
      end
    end

    define_method(:import_batch) do |batch|
      # Use direct import with duplicate handling based on unique address constraint
      Relay::Helium::L1::Account.import(
        batch,
        on_duplicate_key_ignore: true,
        validate: false
      )
    end

    define_method(:list_s3_files) do |bucket_name, prefix|
      file_client = create_s3_client
      file_count = 0
      total_size = 0

      file_client.each_object(
        bucket: bucket_name,
        prefix: prefix
      ) do |object|
        next unless object.key.end_with?(".csv.gz")

        file_count += 1
        size_mb = (object.size / 1024.0 / 1024.0).round(2)
        total_size += object.size

        puts "#{file_count.to_s.rjust(3)}. #{object.key}"
        puts "     Size: #{size_mb} MB"
        puts "     Last Modified: #{object.last_modified}"
        puts
      end

      total_size_mb = (total_size / 1024.0 / 1024.0).round(2)
      puts "Total: #{file_count} files, #{total_size_mb} MB"
    end

    define_method(:create_s3_client) do
      # Reuse the existing L2 file client pattern
      Relay::Helium::L2::FileClient.new
    end
  end
end
