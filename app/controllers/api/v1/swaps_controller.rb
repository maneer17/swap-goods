class Api::V1::SwapsController < ApplicationController
  before_action :set_swap, only: [:update, :destroy, :reject, :accept, :show]

  def index
    
    render json: SwapSerializer.new(Swap.all, is_collection: true).serializable_hash
  end

  def show
    render json: SwapSerializer.new(@swap).serializable_hash
  end

  def create
    ActiveRecord::Base.transaction do
      requester_item = @current_user.items.find(swap_params[:requester_item_id])
      receiver_item = Item.find(swap_params[:receiver_item_id])

      swap = Swap.new(
        requester_item: requester_item,
        receiver_item: receiver_item,
        reason: swap_params[:reason]
      )

      if swap.save
        render json: SwapSerializer.new(swap).serializable_hash, status: :created
      else
        render json: { success: false, errors: swap.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  end

  def update
    updated_requester_item = @current_user.items.find(swap_update_params[:requester_item_id])

    if @swap.update(requester_item: updated_requester_item, reason: swap_update_params[:reason])
      render json: {
        success: true,
        swap: SwapSerializer.new(@swap).serializable_hash,
        message: "swap updated successfully"
      }, status: :ok
    else
      render json: { success: false, errors: @swap.errors.full_messages }
    end
  end

  def destroy
    if @swap.requester_item.user == @current_user || @swap.receiver_item.user == @current_user
      @swap.destroy
      render json: { success: true, message: "Swap cancelled successfully" }, status: :ok
    else
      render json: { success: false, message: "You can't cancel a swap if you're not a part of it" },
             status: :forbidden
    end
  end

  def accept
    if @swap.receiver_item.user == @current_user
      if @swap.update(status: :accepted)
        @swap.transfer_ownership

        render json: {
          success: true,
          message: "Swap accepted successfully!",
          swap: SwapSerializer.new(@swap).serializable_hash
        }
      else
        render json: {
          success: false,
          errors: @swap.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: "Only the receiver can accept a swap"
      }, status: :forbidden
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      success: false,
      errors: ["Swap failed: #{e.message}"]
    }, status: :unprocessable_entity
  end

  def reject
    if @swap.receiver_item.user == @current_user
      if @swap.update(reject_params.merge(status: :rejected))
        render json: {
          success: true,
          message: "Swap request has been successfully rejected",
          swap: SwapSerializer.new(@swap).serializable_hash
        }
      else
        render json: {
          success: false,
          errors: @swap.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: "You can't reject a swap if you aren't the owner of the item"
      }, status: :forbidden
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
