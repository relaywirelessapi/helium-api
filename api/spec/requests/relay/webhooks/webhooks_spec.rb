# typed: false

RSpec.describe "/webhooks", type: :request do
  describe "POST /" do
      context "when the webhook key is valid" do
      it "creates a webhook" do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("WEBHOOK_AUTH_KEYS").and_return("1234567890")

        post webhooks_helius_path, params: {
          source: "helius",
          payload: {
            "signature" => "1234567890",
            "timestamp" => "1234567890",
            "data" => "1234567890"
          }
        }.to_json, headers: {
          "Authorization" => "Bearer 1234567890",
          "Content-Type" => "application/json"
        }

        expect(Relay::Webhooks::Webhook.count).to eq(1)
      end

      it "enqueues the webhook for processing" do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("WEBHOOK_AUTH_KEYS").and_return("1234567890")

        expect {
          post webhooks_helius_path, params: {
            source: "helius",
            payload: {
              "signature" => "1234567890",
              "timestamp" => "1234567890",
              "data" => "1234567890"
            }
          }.to_json, headers: {
            "Authorization" => "Bearer 1234567890",
            "Content-Type" => "application/json"
          }
        }.to have_enqueued_job(Relay::Webhooks::ProcessWebhookJob)
      end
    end

    context "when the webhook key is invalid" do
      it "responds with 401 Unauthorized" do
        post webhooks_helius_path, params: {
          source: "helius",
          payload: {
            "signature" => "1234567890",
            "timestamp" => "1234567890",
            "data" => "1234567890"
          }
        }.to_json, headers: {
          "Content-Type" => "application/json"
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
