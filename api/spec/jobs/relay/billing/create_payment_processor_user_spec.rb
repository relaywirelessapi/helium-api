# typed: false

RSpec.describe Relay::Billing::CreatePaymentProcessorUserJob, type: :job do
  it "creates a payment processor user" do
    user = build_stubbed(:user)
    payment_processor = instance_spy(Pay::Stripe::Customer)
    allow(user).to receive(:payment_processor).and_return(payment_processor)

    described_class.perform_now(user)

    expect(payment_processor).to have_received(:api_record)
  end
end
