class AddRejectionReasonToSwaps < ActiveRecord::Migration[8.0]
  def change
    add_column :swaps, :rejection_reason, :text, null: true
  end
end
