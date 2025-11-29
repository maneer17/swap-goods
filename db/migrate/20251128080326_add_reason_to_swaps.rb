class AddReasonToSwaps < ActiveRecord::Migration[8.0]
  def change
    add_column :swaps, :reason, :text, null: true
  end
end
