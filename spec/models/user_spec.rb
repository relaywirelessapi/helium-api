# typed: false

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build_stubbed(:user)
    expect(user).to be_valid
  end

  describe '#refresh_api_key' do
    let(:user) { create(:user) }

    it 'generates a new API key' do
      expect { user.refresh_api_key }.to change { user.api_key }
    end

    it 'generates a 64-character hexadecimal string' do
      user.refresh_api_key
      expect(user.api_key).to match(/\A[0-9a-f]{64}\z/)
    end

    it 'persists the new API key' do
      user.refresh_api_key
      expect(user.reload.api_key).to be_present
    end

    it 'generates unique keys' do
      keys = Array.new(100) do
        user.refresh_api_key
        user.api_key
      end
      expect(keys.uniq).to eq(keys)
    end
  end
end
