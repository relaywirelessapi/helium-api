# typed: strict

module Relay
  module Helium
    module L2
      class File < ApplicationRecord
        extend T::Sig

        self.table_name = "helium_l2_files"

        sig { returns(T.nilable(FileDefinition)) }
        def definition
          @definition ||= T.let(
            FileDefinition.find(definition_id),
            T.nilable(FileDefinition)
          )
        end
      end
    end
  end
end
