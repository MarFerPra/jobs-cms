require 'rails_helper'

RSpec.describe "Jobs", type: :request do

  describe "GET /jobs" do
    it "gets all jobs" do
      get_with_token jobs_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /jobs" do
    it "gets all jobs with nested attributes" do
      3.times do
        post_with_token jobs_path, job_params_with_nested_attributes
      end
      get_with_token jobs_path
      expect(response).to have_http_status(200)
      parsed_response = JSON.parse(response.body)

      parsed_response.each do |job|
        expect(job['contract']).to satisfy { |contract| contract.present? }
        expect(job['category']).to satisfy { |category| category.present? }
        expect(job['keywords']).to satisfy { |keywords| keywords.present? }
      end
    end
  end

  describe "GET /jobs/page" do
    it "gets all jobs paginated" do

      6.times do |i|
        Job.create!(title: 'Test job '+i.to_s, description: 'Test description', active: 'true')
      end

      get_with_token '/jobs/page', {per: 5, page: 1}
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to be 5

      get_with_token '/jobs/page', {per: 5, page: 2}
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to be 1
    end
  end

  describe "POST /jobs" do
    it "creates a job with category, contract and keywords" do
      post_with_token jobs_path, job_params_with_nested_attributes
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /update" do
    it "updates job" do
      job = Job.create!(title: 'Test job', description: 'Test description', active: 'true')
      put_with_token '/jobs/' + job.id.to_s, { job: {id: job.id, description: 'Updated description' } }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /set_active" do
    it "sets active state in job" do
      job = Job.create!(title: 'Test job', description: 'Test description', active: 'true')
      post_with_token '/jobs/' + job.id.to_s + '/set_active', { id: job.id, active: false }
      expect(response).to have_http_status(:ok)
    end
  end

end

def job_params_with_nested_attributes
  {
    job: {
      title: 'Test job',
      description: 'Test description',
      active: 'true',
      category_attributes: {
        title: 'Rails developer'
      },
      contract_attributes: {
        type_of: 'fulltime'
      },
      keywords_attributes: {
        '0': {
          name: 'key01'
        },
        '1': {
          name: 'key02'
        }
      }
    }
  }
end
