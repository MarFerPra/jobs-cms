class JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :set_active]

  def index
    @jobs = Job.all
    render json: @jobs
  end

  def page
    items_per_page = params.has_key?(:per) ? params[:per] : 10
    page = params.has_key?(:page) ? params[:page] : 1

    offset_value = (page - 1) * items_per_page

    @paginated_jobs = Job.all.offset(offset_value).limit(items_per_page)
    render json: @paginated_jobs
  end

  def show
    render json: @job
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      @job.create_category(params[:job][:category]) if params[:job].has_key?(:category)
      @job.keywords.create(params[:job][:keywords]) if params[:job].has_key?(:keywords)
      @job.create_contract(params[:job][:contract]) if params[:job].has_key?(:contract)
    end

    if @job.errors.blank?
      render json: @job, status: :created, location: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end

  end

  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  def set_active
    if params.has_key?(:active)
      @job.update(active: params[:active])
      render json: @job, status: :ok
    else
      render json: 'Error: Active value not defined.', status: :bad_request
    end
  end

  def destroy
    render json: 'Error: Operation not supported.', status: :bad_request
  end

  private

    def set_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:title, :description, :active,
                                  contract: [:id, :type],
                                  category: [:id, :title],
                                  keywords_attributes: [:id, :name]
                                  )
    end

end
