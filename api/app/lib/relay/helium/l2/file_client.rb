# typed: strict

module Relay
  module Helium
    module L2
      class FileClient
        extend T::Sig

        sig { returns(Aws::S3::Client) }
        attr_reader :s3

        sig { params(s3: Aws::S3::Client).void }
        def initialize(s3: Aws::S3::Client.new(
          region: ENV.fetch("HELIUM_ORACLES_AWS_REGION"),
          credentials: Aws::Credentials.new(
            ENV.fetch("HELIUM_ORACLES_AWS_ACCESS_KEY_ID"),
            ENV.fetch("HELIUM_ORACLES_AWS_SECRET_ACCESS_KEY")
          ),
        ))
          @s3 = s3
        end

        sig { params(bucket: String, prefix: String, start_after: T.nilable(String), blk: T.proc.params(object: T.untyped).void).void }
        def each_object(bucket:, prefix:, start_after: nil, &blk)
          start_after_key = T.let(start_after, T.nilable(String))
          continuation_token = T.let(nil, T.nilable(String))

          loop do
            request_params = {
              bucket: bucket,
              prefix: prefix,
              request_payer: "requester"
            }

            if continuation_token
              request_params[:continuation_token] = continuation_token
            elsif start_after_key
              request_params[:start_after] = start_after_key
              start_after_key = nil
            end

            response = s3.list_objects_v2(request_params)

            response.contents.each do |object|
              yield object
            end

            break unless response.is_truncated
            continuation_token = response.next_continuation_token
          end
        end

        sig { params(bucket: String, key: String, response_target: T.any(Pathname, String)).returns(Seahorse::Client::Response) }
        def get_object(bucket:, key:, response_target:)
          s3.get_object(
            bucket: bucket,
            key: key,
            response_target: response_target,
            request_payer: "requester",
          )
        end
      end
    end
  end
end
