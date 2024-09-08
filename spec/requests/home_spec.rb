require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it 'returns a successful response' do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
