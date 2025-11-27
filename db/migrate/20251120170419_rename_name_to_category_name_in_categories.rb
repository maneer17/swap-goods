class RenameNameToCategoryNameInCategories < ActiveRecord::Migration[8.0]
  def change
    rename_column :categories, :category_name, :category
  end
end
