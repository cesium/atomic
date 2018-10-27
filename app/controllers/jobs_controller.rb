class JobsController < ApplicationController
  load_and_authorize_resource

  def new
    @job = Job.new
  end

  def index
    page = params[:page]

    @jobs = Job.all.order("created_at DESC")
    @jobs = Job.filters(@jobs, params)
    @jobs = @jobs.paginate(page: page, per_page: 5)
  end

  def show
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to @job
    else
      render :new
    end
  end

  def update
    @job = Job.find_by(id: params[:id])

    if @job
      update_job(job_params)
    else
      not_found
    end
  end

  def destroy
    Job.find_by(id: params[:id]).try(:destroy)
    redirect_to jobs_path
  end

  private

  def update_job(params)
    if @job.update(params)
      redirect_to @job
    else
      render :edit
    end
  end

  def job_params
    params.require(:job).permit(:position, :company, :location, :description,
      :email, :link, :contact, :poster, :all_tags)
  end

  def previous_jobs_requested?
    params[:show] == "previous"
  end
end
