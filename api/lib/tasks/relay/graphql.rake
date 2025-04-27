# typed: false

namespace :relay do
  namespace :graphql do
    desc "Generate persisted queries for specific types"
    task generate_persisted_queries: :environment do
      # Ensure the directory exists
      FileUtils.mkdir_p(Rails.root.join("config", "data"))

      # Initialize the generator
      generator = Relay::Graphql::PersistedQueryGenerator.new(Relay::ApplicationSchema, max_depth: 100)

      # Define the types we want to generate queries for
      types = %w[iotRewardShares mobileRewardShares rewardManifests]

      # Generate queries for each type
      queries = types.each_with_object({}) do |type, hash|
        # Convert camelCase to kebab-case for the JSON key
        json_key = type.gsub(/([a-z])([A-Z])/, '\1-\2').downcase
        hash[json_key] = generator.query_for(type)
      end

      # Save to file
      output_path = Rails.root.join("config", "data", "persisted-queries.json")
      File.write(output_path, JSON.pretty_generate(queries))

      puts "Generated persisted queries for #{types.join(', ')}"
      puts "Saved to #{output_path}"
    end
  end
end
