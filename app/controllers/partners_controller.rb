class PartnersController < ApplicationController
  load_and_authorize_resource

  def index
    @partners = Partner.all
  end

  def new
    @partner = Partner.new
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      redirect_to partners_path
    else
      render :new
    end
  end

  def update
    @partner = Partner.find(params[:id])
    if @partner.update(partner_params)
      redirect_to partners_path
    else
      render :edit
    end
  end

  def destroy
    Partner.find(params[:id]).try(:destroy)
    redirect_to partners_path
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :description, :logo, :link)
  end
end
