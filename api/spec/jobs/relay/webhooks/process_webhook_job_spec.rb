# typed: false

RSpec.describe Relay::Webhooks::ProcessWebhookJob do
  context "when the webhook was not processed yet" do
    it "processes the webhook" do
      processor = instance_spy("Relay::Webhooks::WebhookProcessor", process: true)
      webhook = instance_spy("Relay::Webhook", processor: processor, processed?: false)

      described_class.perform_now(webhook)

      expect(processor).to have_received(:process)
    end

    it "marks the webhook as processed" do
      freeze_time do
        processor = instance_spy("Relay::Webhooks::WebhookProcessor", process: true)
        webhook = instance_spy("Relay::Webhook", processor: processor, processed?: false)

        described_class.perform_now(webhook)

        expect(webhook).to have_received(:update!).with(processed_at: Time.current)
      end
    end
  end

  context "when the webhook was already processed" do
    it "does not process the webhook" do
      processor = instance_spy("Relay::Webhooks::WebhookProcessor", process: true)
      webhook = instance_spy("Relay::Webhook", processor: processor, processed?: true)

      described_class.perform_now(webhook)

      expect(processor).not_to have_received(:process)
    end
  end
end
