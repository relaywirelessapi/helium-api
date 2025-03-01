# typed: false

RSpec.describe Relay::Helium::L2::FileDefinitionNotFoundError do
  it "can be instantiated" do
    expect { described_class.new }.not_to raise_error
  end
end
