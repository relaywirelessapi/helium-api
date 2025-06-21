# typed: false

RSpec.describe Relay::Helium::L2::FileProcessor do
  describe "#process" do
    it "processes the file and updates the oracle file" do
      freeze_time do
        messages_in_file = {
          "message1" => {
            record: double("record1"),
            position: 100
          },
          "message2" => {
            record: double("record2"),
            position: 200
          },
          "message3" => {
            record: double("record3"),
            position: 300
          },
          "message4" => {
            record: double("record4"),
            position: 400
          }
        }
        deserializer = stub_deserializer(messages_in_file.transform_values { |v| v[:record] })
        definition = stub_file_definition(deserializer: deserializer)
        file_client = stub_file_client
        file_decoder = stub_file_decoder(messages_in_file.transform_values { |v| v[:position] })
        file = stub_file(definition: definition)

        processor = described_class.new(
          file_client: file_client,
          file_decoder: file_decoder,
          batch_size: 2
        )
        processor.process(file)

        aggregate_failures do
          expect(file).to have_received(:update!).with(started_at: Time.current).ordered
          expect(deserializer).to have_received(:import).with([ messages_in_file["message1"][:record], messages_in_file["message2"][:record] ]).ordered
          expect(file).to have_received(:update!).with(position: 200).ordered
          expect(deserializer).to have_received(:import).with([ messages_in_file["message3"][:record], messages_in_file["message4"][:record] ]).ordered
          expect(file).to have_received(:update!).with(position: 400).ordered
          expect(file).to have_received(:update!).with(completed_at: Time.current).ordered
        end
      end
    end
  end

  private

  define_method(:stub_file_decoder) do |message_positions|
    decoder_results = message_positions.map do |message, position|
      instance_double(
        Relay::Helium::L2::FileDecoder::DecoderResult,
        message:,
        position:
      )
    end

    instance_double(Relay::Helium::L2::FileDecoder).tap do |decoder|
      allow(decoder).to receive(:messages_in).with(
        an_instance_of(String),
        start_position: 0
      ).and_return(decoder_results)
    end
  end

  define_method(:stub_deserializer) do |message_records|
    instance_spy(Relay::Helium::L2::Deserializers::BaseDeserializer).tap do |deserializer|
      message_records.each_pair do |message, record|
        allow(deserializer).to receive(:deserialize).with(message, file: an_instance_of(Relay::Helium::L2::File)).and_return(record)
      end
    end
  end

  define_method(:stub_file) do |definition:|
    build_stubbed(:helium_l2_file, position: 0, started_at: nil).tap do |file|
      allow(file).to receive(:definition).and_return(definition)
      allow(file).to receive(:update!)
    end
  end

  define_method(:stub_file_definition) do |deserializer:|
    instance_double(Relay::Helium::L2::FileDefinition, bucket: "test-bucket", deserializer: deserializer)
  end


  define_method(:stub_file_client) do
    instance_double(Relay::Helium::L2::FileClient).tap do |client|
      allow(client).to receive(:get_object)
    end
  end
end
