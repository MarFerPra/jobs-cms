require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "creates a user" do
      post users_path, user: {name: 'Test User', email: 'test@test.com', password: 'test'}
      expect(response).to have_http_status(:created)
    end
  end
end
