# typed: false
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Relay::Types::BinaryType do
  describe ".coerce_input" do
    it "returns nil for nil input" do
      result = described_class.coerce_input(nil, stub_context)

      expect(result).to be_nil
    end

    context "when the input is binary" do
      it "encodes the binary data to Base64" do
        binary_data = String.new("\x00\x01\x02\x03").force_encoding("ASCII-8BIT")

        result = described_class.coerce_input(binary_data, stub_context)

        expect(result).to eq("AAECAw==")
      end
    end

    context "when the input is not binary" do
      it "raises GraphQL::CoercionError" do
        expect {
          described_class.coerce_input("Hello, world!", stub_context)
        }.to raise_error(GraphQL::CoercionError)
      end
    end
  end

  describe ".coerce_result" do
    it "returns nil for nil input" do
      result = described_class.coerce_result(nil, stub_context)

      expect(result).to be_nil
    end

    context "when the input is binary" do
      it "encodes the binary data to Base64" do
        binary_data = String.new("\x00\x01\x02\x03").force_encoding("ASCII-8BIT")

        result = described_class.coerce_result(binary_data, stub_context)

        expect(result).to eq("AAECAw==")
      end
    end

    context "when the input is not binary" do
      it "raises GraphQL::CoercionError" do
        expect {
          described_class.coerce_result("Hello, world!", stub_context)
        }.to raise_error(GraphQL::CoercionError)
      end
    end
  end

  private

  def stub_context
    instance_double(GraphQL::Query::Context)
  end
end
