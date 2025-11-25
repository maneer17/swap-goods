class Api::V1::ItemsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :index, :show ]
  before_action :set_item, only: [ :show, :update, :delete ]


  def index
    items = Item.all
    render json: ItemSerializer.new(items, is_collection: true).serializable_hash
  end

  def show
    render json: ItemSerializer.new(@item).serializable_hash
  end
  def create
    @item = @current_user.items.new(item_params)
    if @item.save
      render json: ItemSerializer.new(@item).serializable_hash, message: "Item has been created successfully"
    else
        render json: { errors: @item.erros.full_messages }
    end
  end

  def update
    if @item.update(item_params)
      render json: ItemSerializer.new(@item).serializable_hash, message: "Item has been updated successfully"
    else
      render json: { errors: @item.erros.full_messages }
    end
  end

  def delete
    @item.destroy
  end


  private
  def item_params
    params.require(:item).permit(:name, :description, :status, category_ids: [])
  end
  def set_item
    @item = Item.find(params[:id])
  end
end
