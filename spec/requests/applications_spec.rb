require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "GET /applications" do
    it "gets all applications" do
      get_with_token applications_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /applications" do
    it "creates an application on an inactive job" do
      job_not_active = Job.create!(title: 'Test job', description: 'Test description', active: 'false')

      post_with_token applications_path, application_params(job_not_active.id)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to eq('Error: Job deactivated.')
    end

    it "creates an application on a active" do
      job_active = Job.create!(title: 'Test job', description: 'Test description', active: 'true')

      post_with_token applications_path, application_params(job_active.id)
      expect(response).to have_http_status(:created)
    end
  end

end


def application_params(job_id)
  {
    application: {
      job_id: job_id,
      name: 'test',
      email: 'test@test.com',
      cv: 'curriculum',
      cover: 'test'
    }
  }
end
