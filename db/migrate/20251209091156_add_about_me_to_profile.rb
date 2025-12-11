class AddAboutMeToProfile < ActiveRecord::Migration[8.0]
  def change
    add_column :profiles, :description, :text
  end
end
