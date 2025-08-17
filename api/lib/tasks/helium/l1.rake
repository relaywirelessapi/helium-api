# typed: false

namespace :helium do
  namespace :l1 do
    IMPORTER_KLASSES = {
      "accounts" => "Relay::Helium::L1::Importers::AccountImporter",
      "gateways" => "Relay::Helium::L1::Importers::GatewayImporter",
      "transactions" => "Relay::Helium::L1::Importers::TransactionImporter",
      "transaction_actors" => "Relay::Helium::L1::Importers::TransactionActorImporter",
      "packets" => "Relay::Helium::L1::Importers::PacketImporter",
      "rewards" => "Relay::Helium::L1::Importers::RewardImporter",
      "dc_burns" => "Relay::Helium::L1::Importers::DcBurnImporter"
    }.freeze

    define_method(:get_importer_class) do |file_type|
      IMPORTER_KLASSES.fetch(file_type).safe_constantize # rubocop:disable Sorbet/ConstantsFromStrings
    end

    define_method(:valid_file_type?) do |file_type|
      IMPORTER_KLASSES.key?(file_type)
    end

    define_method(:supported_file_types) do
      IMPORTER_KLASSES.keys
    end

    desc "Test all L1 importers by attempting to import the first file for each in a transaction that gets reverted"
    task test_importers: :environment do
      ActiveRecord::Base.transaction do
        puts "Testing all L1 importers..."
        puts

        IMPORTER_KLASSES.each do |file_type, importer_class|
          Rake::Task["helium:l1:import"].invoke(file_type, "data_xaa.csv.gz")
          Rake::Task["helium:l1:import"].reenable
          puts
        end

        puts "Test complete! Rolling back DB transaction..."
        raise ActiveRecord::Rollback
      end
    end

    desc "Import all Helium L1 data of a specific type from S3 bucket"
    task :import_all, [ :file_type ] => :environment do |_t, args|
      file_type = args[:file_type]

      unless valid_file_type?(file_type)
        puts "Error: Invalid file type '#{file_type}'"
        puts "Supported file types: #{supported_file_types.join(', ')}"
        exit 1
      end

      importer_class = get_importer_class(file_type)
      puts "Starting import of Helium L1 #{file_type} from S3..."

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new
        importer = importer_class.new

        orchestrator.each_file(importer) do |key|
          puts "Importing file: #{key}"
          orchestrator.import_file(importer, key)
        end

        puts "Import completed successfully!"
      rescue StandardError => e
        puts "Error during import: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end

    desc "List all available L1 files of a specific type in S3"
    task :list_files, [ :file_type ] => :environment do |_t, args|
      file_type = args[:file_type]

      unless valid_file_type?(file_type)
        puts "Error: Invalid file type '#{file_type}'"
        puts "Supported file types: #{supported_file_types.join(', ')}"
        exit 1
      end

      importer_class = get_importer_class(file_type)

      puts "Listing L1 #{file_type} files in S3..."
      puts "Prefix: #{importer_class.new.prefix}"
      puts

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new
        importer = importer_class.new

        file_count = 0

        orchestrator.each_file(importer) do |key|
          file_count += 1
          puts "#{file_count.to_s.rjust(3)}. #{key}"
        end

        puts
        puts "Total: #{file_count} files"
      rescue StandardError => e
        puts "Error listing files: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end

    desc "Import a specific L1 file from S3 by file type and S3 key"
    task :import, [ :file_type, :s3_key ] => :environment do |_t, args|
      file_type = args[:file_type]
      s3_key = args[:s3_key]

      if file_type.blank? || s3_key.blank?
        puts "Error: File type and S3 key are required"
        puts "Usage: rake helium:l1:import_file[file_type,s3_key]"
        puts "Example: rake helium:l1:import_file[accounts,data_xaa.csv.gz]"
        exit 1
      end

      unless valid_file_type?(file_type)
        puts "Error: Invalid file type '#{file_type}'"
        puts "Supported file types: #{supported_file_types.join(', ')}"
        exit 1
      end

      importer_class = get_importer_class(file_type)

      puts "Importing #{file_type} file: #{s3_key}"

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new
        importer = importer_class.new

        orchestrator.import_file(importer, s3_key)
        puts "File import completed successfully!"
      rescue StandardError => e
        puts "Error during import: #{e.message}"
        puts e.backtrace.join("\n") if e.backtrace
        exit 1
      end
    end
  end
end
