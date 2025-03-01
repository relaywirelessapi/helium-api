# typed: false

RSpec.describe Relay::Helium::L2::FileDecoder do
  describe "#messages_in" do
    context "without a start_position" do
      it "yields each message in the file" do
        messages = [
          "First test message",
          "Second test message with more content",
          "Third test message"
        ]
        fixture_path = generate_test_fixture_file(messages:)

        decoder = described_class.new
        enumerator = decoder.messages_in(fixture_path)

        expect(enumerator.to_a).to match_array(to_matchers(messages_and_positions_for(messages)))
      end
    end

    context "with a start_position" do
      it "starts reading from the specified position" do
        messages = [
          "First test message",
          "Second test message with more content",
          "Third test message"
        ]
        fixture_path = generate_test_fixture_file(messages:)

        decoder = described_class.new
        enumerator = decoder.messages_in(fixture_path, start_position: positions_for(messages).first)

        expect(enumerator.to_a).to match_array(to_matchers(messages_and_positions_for(messages).drop(1)))
      end
    end
  end

  private

  def generate_test_fixture_file(messages: [])
    fixture_path = Rails.root.join("tmp", "test_messages_#{SecureRandom.uuid}.gz")

    FileUtils.mkdir_p(File.dirname(fixture_path))

    Zlib::GzipWriter.open(fixture_path) do |gz|
      messages.each do |message|
        gz.write([ message.bytesize ].pack('N'))
        gz.write(message)
      end
    end

    fixture_path
  end

  def positions_for(messages)
    messages.each_with_object([]) do |message, positions|
      previous_position = positions.last || 0
      positions << previous_position + 4 + message.bytesize
    end
  end

  def messages_and_positions_for(messages)
    messages.zip(positions_for(messages))
  end

  def to_matchers(messages_and_positions)
    messages_and_positions.map do |message, position|
      have_attributes(
        message: message,
        position: position
      )
    end
  end
end
