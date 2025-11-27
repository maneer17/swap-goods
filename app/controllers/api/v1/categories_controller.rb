class Api::V1::CategoriesController < ApplicationController
  skip_before_action :authenticate_user, only: :index
  def index
    categories = Category.all.order(name: :asc)
    render json: categories
  end
end
