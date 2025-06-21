# typed: false

RSpec.describe Relay::Helium::L2::FileClient do
  describe "#each_object" do
    context "when no start_after is provided" do
      it "lists objects with the correct parameters" do
        s3_object1 = double("S3Object1")
        s3_object2 = double("S3Object2")
        s3_client = stub_s3_client.tap do |s3|
          stub_object_list(
            s3,
            bucket: "test-bucket",
            prefix: "test-category/test-prefix",
            contents: [ s3_object1, s3_object2 ],
            is_truncated: false
          )
        end

        client = build_file_client(s3: s3_client)

        expect do |b|
          client.each_object(bucket: "test-bucket", prefix: "test-category/test-prefix", &b)
        end.to yield_successive_args(s3_object1, s3_object2)
      end
    end

    context "when start_after is provided" do
      it "lists objects with start_after parameter" do
        s3_object = double("S3Object1")
        s3_client = stub_s3_client.tap do |s3|
          stub_object_list(
            s3,
            bucket: "test-bucket",
            prefix: "test-category/test-prefix",
            contents: [ s3_object ],
            is_truncated: false,
            start_after: "test-category/test-prefix/start-after-key"
          )
        end

        client = build_file_client(s3: s3_client)

        expect do |b|
          client.each_object(
            bucket: "test-bucket",
            prefix: "test-category/test-prefix",
            start_after: "test-category/test-prefix/start-after-key",
            &b
          )
        end.to yield_successive_args(s3_object)
      end
    end

    context "when response is truncated" do
      it "continues listing objects with continuation token" do
        s3_object1 = double("S3Object1")
        s3_object2 = double("S3Object2")
        s3_client = stub_s3_client.tap do |s3|
          stub_object_list(
            s3,
            bucket: "test-bucket",
            prefix: "test-category/test-prefix",
            contents: [ s3_object1 ],
            is_truncated: true,
            next_continuation_token: "continuation-token"
          )
          stub_object_list(
            s3,
            bucket: "test-bucket",
            prefix: "test-category/test-prefix",
            contents: [ s3_object2 ],
            is_truncated: false,
            continuation_token: "continuation-token"
          )
        end

        client = build_file_client(s3: s3_client)

        expect do |b|
          client.each_object(bucket: "test-bucket", prefix: "test-category/test-prefix", &b)
        end.to yield_successive_args(s3_object1, s3_object2)
      end
    end
  end

  describe "#get_object" do
    it "forwards the call to the S3 client with the correct parameters" do
      s3_client = stub_s3_client
      response = instance_double(Seahorse::Client::Response)
      response_target = instance_double(Pathname)

      expect(s3_client).to receive(:get_object).with(
        bucket: "test-bucket",
        key: "test-key",
        response_target: response_target,
        request_payer: "requester"
      ).and_return(response)

      client = build_file_client(s3: s3_client)
      result = client.get_object(
        bucket: "test-bucket",
        key: "test-key",
        response_target: response_target
      )

      expect(result).to eq(response)
    end
  end

  private

  define_method(:build_file_client) do |s3:|
    described_class.new(s3:)
  end

  define_method(:stub_s3_client) do
    instance_double(Aws::S3::Client)
  end

  define_method(:stub_object_list) do |s3_client, bucket:, prefix:, contents:, is_truncated:, next_continuation_token: nil, start_after: nil, continuation_token: nil|
    response = instance_double(
      Aws::S3::Types::ListObjectsV2Output,
      contents: contents,
      is_truncated: is_truncated
    )

    if next_continuation_token
      allow(response).to receive(:next_continuation_token).and_return(next_continuation_token)
    end

    params = {
      bucket: bucket,
      prefix: prefix,
      request_payer: "requester"
    }

    params[:start_after] = start_after if start_after
    params[:continuation_token] = continuation_token if continuation_token

    allow(s3_client).to receive(:list_objects_v2).with(params).and_return(response)

    response
  end
end
