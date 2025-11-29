class Api::V1::SwapsController < ApplicationController
  before_action :set_swap, only:  [ :update, :destroy, :reject, :accept, :show ]

  def index
    render json: Swap.all
  end

  def item_swaps
  end
  def show
    render json: @swap
  end
  def create
    ActiveRecord::Base.transaction do
      requester_item = @current_user.items.find(swap_params[:requester_item_id])
      receiver_item = Item.find(swap_params[:receiver_item_id])
      swap = Swap.new(requester_item: requester_item, receiver_item: receiver_item, reason: swap_params[:reason])
      if swap.save
        requester_item.update!(status: :pending)
        render json: swap, status: :created
      else
        render json: { success: false, errors: swap.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  def update
    updated_requester_item = @current_user.items.find(swap_update_params[:requester_item_id])
    if @swap.update(requester_item: updated_requester_item, reason: swap_update_params[:reason])
      render json: { success: true, swap: @swap, message: "swap updated successfully" }, status: :ok
    else
      render json: { success: false, errors: @swap.errors.full_messages }
    end
  end

  def destroy
    if @swap.requester_item.user == @current_user || @swap.receiver_item.user == @current_user
      @swap.destroy
      render json: { success: true, message: "Swap cancelled successfully" }, status: :ok
    else
      render json: { success: false, message: "You can't cancel a swap if you're not a part of it" }, status: :forbidden
    end
  end

  def accept
    if @swap.receiver_item.user == @current_user
      Swap.transaction do
        if @swap.update(status: :accepted)
          temp = @swap.receiver_item.user
          @swap.receiver_item.update!(user: @swap.requester_item.user, status: :swapped)
          @swap.requester_item.update!(user: temp, status: :swapped)
          Swap.where(receiver_item: @swap.receiver_item, status: :pending).destroy_all

          # Success response
          render json: {
            success: true,
            message: "Swap accepted successfully!",
            swap: @swap
          }
          return  # Important: return after render in transaction
        else
          render json: {
            success: false,
            errors: @swap.errors.full_messages
          }, status: :unprocessable_entity
          return
        end
      end
    else
      # Authorization failure
      render json: {
        success: false,
        message: "Only the receiver can accept a swap"
      }, status: :forbidden
    end
  rescue ActiveRecord::RecordInvalid => e
    # Transaction failure
    render json: {
      success: false,
      errors: [ "Swap failed: #{e.message}" ]
    }, status: :unprocessable_entity
  end


  def reject
    if @swap.receiver_item.user == @current_user
      if @swap.update(reject_params.merge(status: :rejected))
        render json: { success: true, message: "Swap request has been successfully rejected", swap: @swap }
      else
        render json: { success: false, errors: @swap.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: "You can't reject a swap if you aren't the owner of the item" }, status: :forbidden
    end
  end


  private

  def swap_params
    params.require(:swap).permit(:requester_item_id, :receiver_item_id, :reason)
  end
  def reject_params
    params.permit(:rejection_reason)
  end
  def swap_update_params
    params.require(:swap).permit(:requester_item_id, :reason)
  end
  def set_swap
    @swap = Swap.find(params[:id])
  end
end
