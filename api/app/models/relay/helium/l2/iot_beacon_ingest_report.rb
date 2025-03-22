# typed: strict
# frozen_string_literal: true

module Relay
  module Helium
    module L2
      class IotBeaconIngestReport < ApplicationRecord
        self.table_name = "helium_l2_iot_beacon_ingest_reports"
      end
    end
  end
end
