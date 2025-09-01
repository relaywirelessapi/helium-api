# typed: strict

module Relay
  module Billing
    class Feature
      extend T::Sig
      extend T::Helpers

      abstract!

      sig { abstract.returns(String) }
      def name
      end

      sig { abstract.returns(String) }
      def description
      end
    end
  end
end
