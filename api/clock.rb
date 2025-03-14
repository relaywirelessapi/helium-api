# typed: strict

require "clockwork"

require "./config/boot"
require "./config/environment"

module Clockwork
  every(5.minutes, "helium.l2.schedule_file_definition_pulls") do
    Relay::Helium::L2::ScheduleFileDefinitionPullsJob.perform_later
  end
end
