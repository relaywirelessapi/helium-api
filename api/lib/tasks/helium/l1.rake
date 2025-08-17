# typed: false

namespace :helium do
  namespace :l1 do
    define_method(:get_importer_class) do |file_type|
      class_name = "Relay::Helium::L1::Importers::#{file_type.classify}Importer"
      class_name.safe_constantize # rubocop:disable Sorbet/ConstantsFromStrings
    end

    define_method(:valid_file_type?) do |file_type|
      get_importer_class(file_type).present?
    end

    define_method(:supported_file_types) do
      Dir[Rails.root.join("app/lib/relay/helium/l1/importers/*_importer.rb")].map do |file|
        File.basename(file, "_importer.rb")
      end
    end

    desc "Import all Helium L1 data of a specific type from S3 bucket"
    task :import_all, [ :file_type ] => :environment do |_t, args|
      file_type = args[:file_type] || "accounts"
      bucket_name = "foundation-helium-l1-archive-requester-pays"

      unless valid_file_type?(file_type)
        puts "Error: Invalid file type '#{file_type}'"
        puts "Supported file types: #{supported_file_types.join(', ')}"
        exit 1
      end

      importer_class = get_importer_class(file_type)
      puts "Starting import of Helium L1 #{file_type} from S3..."
      puts "Bucket: #{bucket_name}"
      puts "Prefix: #{importer_class.new.prefix}"

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new(bucket: bucket_name)
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
      file_type = args[:file_type] || "accounts"

      unless valid_file_type?(file_type)
        puts "Error: Invalid file type '#{file_type}'"
        puts "Supported file types: #{supported_file_types.join(', ')}"
        exit 1
      end

      bucket_name = "foundation-helium-l1-archive-requester-pays"
      importer_class = get_importer_class(file_type)

      puts "Listing L1 #{file_type} files in S3..."
      puts "Bucket: #{bucket_name}"
      puts "Prefix: #{importer_class.new.prefix}"
      puts

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new(bucket: bucket_name)
        importer = importer_class.new
        file_parser = orchestrator.file_parser

        file_count = 0
        total_size_mb = 0

        file_parser.each_file(bucket_name, importer.prefix) do |key|
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

      bucket_name = "foundation-helium-l1-archive-requester-pays"
      importer_class = get_importer_class(file_type)

      puts "Importing specific #{file_type} file: #{s3_key}"
      puts "Bucket: #{bucket_name}"

      begin
        orchestrator = Relay::Helium::L1::ImportOrchestrator.new(bucket: bucket_name)
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
