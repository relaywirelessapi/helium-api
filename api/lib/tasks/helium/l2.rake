# typed: false

namespace :helium do
  namespace :l2 do
    desc "List all available file definitions"
    task list_definitions: :environment do
      display_definitions_list
    end

    desc "Process a specific file by its S3 key for a given definition ID"
    task :process_specific_file, [ :definition_id, :s3_key ] => :environment do |_t, args|
      definition_id = args[:definition_id]
      s3_key = args[:s3_key]

      if definition_id.blank? || s3_key.blank?
        puts "Error: Definition ID and S3 key are required"
        puts "Usage: rake helium_l2:process_specific_file[definition_id,s3_key]"
        exit 1
      end

      begin
        definition = Relay::Helium::L2::FileDefinition.find!(definition_id)
        display_definition_details(definition)

        unless verify_s3_file_exists(definition, s3_key)
          puts "Error: File not found in S3 bucket: #{definition.bucket}, key: #{s3_key}"
          exit 1
        end

        puts "File found: #{s3_key}"
        process_s3_file(definition, s3_key)
      rescue ArgumentError => e
        exit_with_definition_not_found_error(e)
      rescue StandardError => e
        exit_with_error(e)
      end
    end

    desc "Pull the latest file for a given definition ID and process it"
    task :process_latest_file, [ :definition_id ] => :environment do |_t, args|
      definition_id = args[:definition_id]

      if definition_id.blank?
        puts "Error: Definition ID is required"
        puts "Usage: rake helium_l2:process_latest_file[definition_id]"
        exit 1
      end

      begin
        definition = Relay::Helium::L2::FileDefinition.find!(definition_id)
        display_definition_details(definition)

        latest_key = find_latest_s3_file(definition)

        if latest_key.nil?
          puts "No files found for definition: #{definition.id}"
          exit 0
        end

        puts "Found latest file: #{latest_key}"
        process_s3_file(definition, latest_key)
      rescue ArgumentError => e
        exit_with_definition_not_found_error(e)
      rescue StandardError => e
        exit_with_error(e)
      end
    end

    private

    define_method(:display_definition_details) do |definition|
      puts "Found definition: #{definition.id} (bucket: #{definition.bucket}, prefix: #{definition.s3_prefix})"
    end

    define_method(:display_file_processing_results) do |file|
      puts "File processed successfully!"
      puts "Started at: #{file.started_at}"
      puts "Completed at: #{file.completed_at}"
      puts "Last processed position: #{file.position}"
    end

    define_method(:display_definitions_list) do |definitions = Relay::Helium::L2::FileDefinition.all|
      if definitions.empty?
        puts "No file definitions found"
      else
        puts "Available definitions:"
        definitions.each do |definition|
          puts "  - #{definition.id} (bucket: #{definition.bucket}, prefix: #{definition.s3_prefix})"
        end
      end
    end

    define_method(:exit_with_definition_not_found_error) do |error|
      puts "Error: #{error.message}"
      display_definitions_list
      exit 1
    end

    define_method(:exit_with_error) do |error|
      puts "Error: #{error.message}"
      puts error.backtrace.join("\n") if error.backtrace
      exit 1
    end

    define_method(:process_s3_file) do |definition, s3_key|
      key_parts = s3_key.split("/")
      category = key_parts[0..-2].join("/")
      name = key_parts[-1]

      if existing_file = Relay::Helium::L2::File.find_by(category: category, name: name)
        puts "File record already exists with category: #{category}, name: #{name}. Re-processing from scratch..."
        existing_file.destroy!
      end

      file = Relay::Helium::L2::File.create!(
        definition_id: definition.id,
        category: category,
        name: name
      )

      puts "Processing file..."
      Relay::Helium::L2::FileProcessor.new.process(file, skip_import: false)

      display_file_processing_results(file)
    end

    define_method(:find_latest_s3_file) do |definition|
      file_client = Relay::Helium::FileClient.new
      latest_key = nil

      puts "Searching for latest file in bucket: #{definition.bucket}, prefix: #{definition.s3_prefix}..."

      file_client.each_object(
        bucket: definition.bucket,
        prefix: definition.s3_prefix
      ) do |object|
        if latest_key.nil? || object.key > latest_key
          latest_key = object.key
        end
      end

      latest_key
    end

    define_method(:verify_s3_file_exists) do |definition, s3_key|
      file_client = Relay::Helium::FileClient.new

      puts "Checking if file exists in bucket: #{definition.bucket}, key: #{s3_key}..."

      begin
        file_client.s3.head_object(
          bucket: definition.bucket,
          key: s3_key,
          request_payer: "requester"
        )
        true
      rescue Aws::S3::Errors::NoSuchKey => _e
        false
      end
    end
  end
end
