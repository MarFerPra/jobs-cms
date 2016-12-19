require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "GET /applications" do
    context "without credentials" do
      it "tries to access restricted route" do
        get applications_path
        expect(response).to have_http_status(401)
      end
    end

    context "with credentials" do
      it "tries to access restricted route" do

        user = User.create!(email: 'test@test.com', name: 'test', password: 'test')

        post '/authenticate', params: {email: 'test@test.com', password: 'test'}
        parsed_response = JSON.parse(response.body)
        auth_token = parsed_response['auth_token']

        get applications_path, headers: { 'Authorization': auth_token }
        expect(response).to have_http_status(200)
      end
    end
  end
end
