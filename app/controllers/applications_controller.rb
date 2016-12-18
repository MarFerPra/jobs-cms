class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show]
  before_action :set_job, only: [:create]

  def index
    @applications = Application.all

    render json: @applications
  end

  def show
    render json: @application
  end

  def create
    @application = Application.new(application_params)

    if @job.present? && @application.save

      if @job.active
        ApplicationsMailer.new_application(@application).deliver
        render json: @application, status: :created, location: @application
      else
        render json: 'Error: Job deactivated.', status: :unprocessable_entity
      end

    else
      render json: @application.errors, status: :unprocessable_entity
    end

  end

  private

    def set_application
      @application = Application.find(params[:id])
    end

    def set_job
      @job = Job.find(params[:application][:job_id])
    end

    def application_params
      params.require(:application).permit(:name, :email, :cover, :cv, :job_id)
    end
end
