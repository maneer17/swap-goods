class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
