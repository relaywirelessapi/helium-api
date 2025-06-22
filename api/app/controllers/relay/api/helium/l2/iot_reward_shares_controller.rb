# typed: strict
# frozen_string_literal: true

module Relay
  module Api
    module Helium
      module L2
        class IotRewardSharesController < ResourceController
          extend T::Sig

          class IndexContract < ResourceController::IndexContract
            attribute :from, :datetime
            attribute :to, :datetime
            attribute :hotspot_key, :string
            attribute :reward_type, :string

            validates :from, presence: true, comparison: { allow_blank: true, less_than: :to }
            validates :to, presence: true, comparison: { allow_blank: true, greater_than: :from }
          end

          sig { void }
          def index
            contract = build_and_validate_contract(IndexContract)

            relation = Relay::Helium::L2::IotRewardShare.order(end_period: :asc)

            relation = relation.where(end_period: contract.from..contract.to)
            relation = relation.where(hotspot_key: contract.hotspot_key) if contract.hotspot_key.present?
            relation = relation.where(reward_type: contract.reward_type) if contract.reward_type.present?

            relation = paginate(relation)

            render json: render_collection(relation, blueprint: IotRewardShareBlueprint)
          end
        end
      end
    end
  end
end
