class Api::V1::SwapsController < ApplicationController
  def create
    swap = Swap.new(swap_params)

    if swap.save
      render json: {
        success: true,
        requester_item: ItemSerializer.new(
          Item.find(swap.requester_item_id)
        ).serializable_hash,

        receiver_item: ItemSerializer.new(
          Item.find(swap.receiver_item_id)
        ).serializable_hash,

        status: swap.status
      }, status: :created

    else
      render json: {
        success: false,
        errors: swap.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def swap_params
    params.require(:swap).permit(:requester_item_id, :receiver_item_id)
  end
end
