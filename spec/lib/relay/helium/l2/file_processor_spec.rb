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

  def stub_file_decoder(message_positions)
    decoder_results = message_positions.map do |message, position|
      instance_double(
        Relay::Helium::L2::FileDecoder::DecoderResult,
        message:,
        position:
      )
    end

    instance_double(Relay::Helium::L2::FileDecoder).tap do |decoder|
      allow(decoder).to receive(:messages_in).and_return(decoder_results)
    end
  end

  def stub_deserializer(message_records)
    instance_spy(Relay::Helium::L2::Deserializers::BaseDeserializer).tap do |deserializer|
      message_records.each_pair do |message, record|
        allow(deserializer).to receive(:deserialize).with(message).and_return(record)
      end
    end
  end

  def stub_file(definition:)
    instance_spy(Relay::Helium::L2::File).tap do |f|
      allow(f).to receive(:definition).and_return(definition)
    end
  end

  def stub_file_definition(deserializer:)
    instance_double(Relay::Helium::L2::FileDefinition, bucket: "test-bucket", deserializer: deserializer)
  end


  def stub_file_client
    instance_double(Relay::Helium::L2::FileClient).tap do |client|
      allow(client).to receive(:get_object)
    end
  end
end
