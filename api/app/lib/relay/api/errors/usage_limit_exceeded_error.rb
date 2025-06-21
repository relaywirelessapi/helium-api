# typed: true

module Relay
  module Api
    module Errors
      class UsageLimitExceededError < BaseError
        include ActionView::Helpers::NumberHelper

        attr_reader :usage_limit, :usage_resets_at

        MESSAGE = <<~MESSAGE.gsub("\n", " ").strip
          You have exhausted your API usage limit of %<usage_limit>s requests/month.
          Your usage resets at %<usage_resets_at>s.
        MESSAGE

        def initialize(usage_limit:, usage_resets_at:)
          super(
            code: "usage_limit_exceeded",
            message: format(
              MESSAGE,
               usage_limit: number_with_delimiter(usage_limit),
               usage_resets_at: usage_resets_at.strftime("%Y-%m-%d %H:%M:%S %Z"),
            ),
            doc_url: "https://docs.relaywireless.com/usage-limits#plan-limits",
            status_code: :payment_required,
          )

          @usage_limit = usage_limit
          @usage_resets_at = usage_resets_at
        end
      end
    end
  end
end
