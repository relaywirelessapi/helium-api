# typed: strict

module Relay
  module Solana
    module Idl
      class ScalarTypeDefinition < TypeDefinition
        extend T::Sig

        class << self
          extend T::Sig

          sig { params(data: String).returns(ScalarTypeDefinition) }
          def from_data(data)
            new(type: data.to_sym.downcase)
          end
        end

        sig { returns(Symbol) }
        attr_reader :type

        sig { returns(Relay::Base58Encoder) }
        attr_reader :base58_encoder

        sig { params(type: Symbol, base58_encoder: Relay::Base58Encoder).void }
        def initialize(type:, base58_encoder: Relay::Base58Encoder.new)
          @type = type
          @base58_encoder = base58_encoder
        end

        sig do
          params(
            data: String,
            offset: Integer,
            program: ProgramDefinition
          ).returns([ T.untyped, Integer ])
        end
        def deserialize(data, offset:, program:)
          method_name = "deserialize_#{type}"

          if respond_to?(method_name, true)
            send(method_name, data, offset)
          else
            raise ArgumentError, "Unsupported scalar type: #{type}"
          end
        end

        private

        sig { params(data: String, offset: Integer, required_bytes: Integer).void }
        def check_bounds(data, offset, required_bytes)
          available_bytes = data.length - offset
          if available_bytes < required_bytes
            raise(
              DeserializationError,
              "Need #{required_bytes} bytes at offset #{offset}, but only #{available_bytes} bytes available (data length: #{data.length})"
            )
          end
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_u8(data, offset)
          check_bounds(data, offset, 1)
          bytes, new_offset = [ data[offset, 1], offset + 1 ]
          [ T.cast(bytes, String).unpack1("C"), new_offset ]
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_u16(data, offset)
          check_bounds(data, offset, 2)
          bytes, new_offset = [ data[offset, 2], offset + 2 ]
          [ T.cast(bytes, String).unpack1("v"), new_offset ] # little endian
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_u32(data, offset)
          check_bounds(data, offset, 4)
          bytes, new_offset = [ data[offset, 4], offset + 4 ]
          [ T.cast(bytes, String).unpack1("V"), new_offset ] # little endian
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_u64(data, offset)
          check_bounds(data, offset, 8)
          bytes, new_offset = [ data[offset, 8], offset + 8 ]
          [ T.cast(bytes, String).unpack1("Q<"), new_offset ] # little endian
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_i8(data, offset)
          check_bounds(data, offset, 1)
          bytes, new_offset = [ data[offset, 1], offset + 1 ]
          [ T.cast(bytes, String).unpack1("c"), new_offset ]
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_i16(data, offset)
          check_bounds(data, offset, 2)
          bytes, new_offset = [ data[offset, 2], offset + 2 ]
          [ T.cast(bytes, String).unpack1("s<"), new_offset ] # little endian signed
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_i32(data, offset)
          check_bounds(data, offset, 4)
          bytes, new_offset = [ data[offset, 4], offset + 4 ]
          [ T.cast(bytes, String).unpack1("l<"), new_offset ] # little endian signed
        end

        sig { params(data: String, offset: Integer).returns([ Integer, Integer ]) }
        def deserialize_i64(data, offset)
          check_bounds(data, offset, 8)
          bytes, new_offset = [ data[offset, 8], offset + 8 ]
          [ T.cast(bytes, String).unpack1("q<"), new_offset ] # little endian signed
        end

        sig { params(data: String, offset: Integer).returns([ T::Boolean, Integer ]) }
        def deserialize_bool(data, offset)
          check_bounds(data, offset, 1)
          bytes, new_offset = [ data[offset, 1], offset + 1 ]
          value = T.cast(bytes, String).unpack1("C")
          [ value != 0, new_offset ]
        end

        sig { params(data: String, offset: Integer).returns([ String, Integer ]) }
        def deserialize_pubkey(data, offset)
          check_bounds(data, offset, 32)
          pubkey_bytes, new_offset = [ data[offset, 32], offset + 32 ]
          [ base58_encoder.base58_from_data(T.cast(pubkey_bytes, String)), new_offset ]
        end

        sig { params(data: String, offset: Integer).returns([ String, Integer ]) }
        def deserialize_string(data, offset)
          check_bounds(data, offset, 4)
          length, new_offset = [ T.cast(data[offset, 4], String).unpack1("V"), offset + 4 ]
          check_bounds(data, new_offset, length)
          bytes, final_offset = [ T.cast(data[new_offset, length], String).force_encoding("UTF-8"), new_offset + length ]
          [ bytes, final_offset ]
        end

        sig { params(data: String, offset: Integer).returns([ String, Integer ]) }
        def deserialize_bytes(data, offset)
          check_bounds(data, offset, 4)
          length_bytes, new_offset = [ data[offset, 4], offset + 4 ]
          length = T.cast(length_bytes, String).unpack1("V") # little endian u32
          check_bounds(data, new_offset, length)
          [ Base64.strict_encode64(T.cast(data[new_offset, length], String)), new_offset + length ]
        end
      end
    end
  end
end
