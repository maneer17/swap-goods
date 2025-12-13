class Api::V1::ItemsController < ApplicationController
  skip_before_action :authenticate_user, only: [ :index, :show ]
  before_action :set_item, only: [ :show, :update, :destroy, :outgoing_requests, :incoming_requests ]
  before_action :authorize_user, only: [ :update, :destroy ]

  def index
    items = Item.all
    items = items.search(params[:q]) if params[:q].present?
    items = items.by_locations(params[:locations]) if params[:locations].present?
    items = items.by_status(params[:status]) if params[:status].present?
    items = items.by_category(params[:categories]) if params[:categories].present?
    render json: ItemSerializer.new(items, is_collection: true).serializable_hash
  end


  def my_items
    items = @current_user.items.all
    render json: ItemSerializer.new(items, is_collection: true).serializable_hash
  end
  def show
    render json: ItemSerializer.new(@item).serializable_hash
  end

  def incoming_requests
    incomings = @item.incoming_swaps
    render json: SwapSerializer.new(incomings, is_collection: true).serializable_hash
  end

  def outgoing_requests
    outgoings = @item.outgoing_swaps
    render json: SwapSerializer.new(outgoings, is_collection: true).serializable_hash
  end
  def create
    @item = @current_user.items.new(item_params)

    # Handle single or multiple images
    if params[:images].present?
      Array.wrap(params[:images]).each do |img|
        @item.images.attach(img)
      end
    end

    if @item.save
      render json: {
        success: true,
        message: "Item has been created successfully",
        data: ItemSerializer.new(@item).serializable_hash
      }, status: :created
    else
      render json: { success: false, errors: @item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: {
        message: "Item updated successfully",
        data: ItemSerializer.new(@item).serializable_hash
      }
    else
      render json: { errors: @item.errors.full_messages }
    end
  end

  def destroy
    @item.destroy
    render json: { message: "Item deleted successfully" }
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :status, category_ids: [])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def authorize_user
    render json: { message: "Not authorized" }, status: :unauthorized unless @current_user.id == @item.user_id
  end
end
