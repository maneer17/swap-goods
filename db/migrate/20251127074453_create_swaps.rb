class CreateSwaps < ActiveRecord::Migration[8.0]
  def change
    create_table :swaps do |t|
      t.references :requester_item, null: false, foreign_key: { to_table: :items }
      t.references :receiver_item, null: false, foreign_key: { to_table: :items }
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
