class LinksController < ApplicationController
  before_action :prevent_unauthorized_user_access, only: [:new, :edit]
  def index
    @links = Link.all
  end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to root_path, notice: "Link successfully created"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  private

  def link_params
    params.require(:link).permit(:title, :url, :description)
  end
end
