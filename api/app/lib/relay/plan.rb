# typed: strict

module Relay
  class Plan < StaticModel
    extend T::Sig

    attribute :name, :string
    attribute :description, :string
    attribute :api_usage_limit, :integer
    attribute :features, array: true, default: []

    validates :name, presence: true
    validates :description, presence: true
    validates :api_usage_limit, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :features, presence: true

    class << self
      extend T::Sig

      sig { returns(T::Array[T.attached_class]) }
      def all
        [
          new(
            id: "beta",
            name: "Beta",
            description: "Free Beta plan for Helium Community enthusiasts.",
            api_usage_limit: 100_000,
            features: [
              "100,000 data credits a month",
              "Entire Helium Solana L2 historical data",
              "All beta endpoints"
            ]
          )
        ]
      end
    end
  end
end
