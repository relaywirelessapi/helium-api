# typed: false

RSpec::Matchers.define :be_paginated_collection do |expected_records|
  match do |actual|
    @actual = actual
    return false unless actual.is_a?(Hash) && actual.key?("records") && actual.key?("meta")
    return false unless actual["meta"].is_a?(Hash) && actual["meta"].key?("pagination")

    pagination = actual["meta"]["pagination"]
    return false unless pagination.is_a?(Hash)

    # Check for required pagination keys
    required_keys = %w[count total_pages current_page next_page prev_page]
    return false unless required_keys.all? { |key| pagination.key?(key) }

    @records = @expected_records || []
    expected_ids = @records.map(&:id).sort
    actual_ids = actual["records"].map { |r| r["id"] }.sort

    actual["meta"]["pagination"]["count"] == @records.size && actual_ids == expected_ids
  end

  chain :with do |expected_records|
    @expected_records = expected_records
  end

  failure_message do
    base_message = if !@actual.is_a?(Hash) || !@actual.key?("records") || !@actual.key?("meta")
      "expected response to be a paginated collection, but it was not a valid hash with 'records' and 'meta' keys"
    elsif !@actual["meta"].is_a?(Hash) || !@actual["meta"].key?("pagination")
      "expected response to have a 'meta.pagination' key"
    elsif !@actual["meta"]["pagination"].is_a?(Hash)
      "expected response to have a valid 'meta.pagination' hash"
    elsif !%w[count total_pages current_page next_page prev_page].all? { |key| @actual["meta"]["pagination"].key?(key) }
      missing_keys = %w[count total_pages current_page next_page prev_page] - @actual["meta"]["pagination"].keys
      "expected response to have pagination keys: #{missing_keys.join(', ')}"
    else
      "expected paginated collection to have #{@records.size} record(s) with IDs #{@records.map(&:id)}."
    end

    pretty_response = begin
      JSON.pretty_generate(@actual)
    rescue
      @actual.inspect
    end

    "#{base_message}\n\nActual response:\n#{pretty_response}"
  end
end
