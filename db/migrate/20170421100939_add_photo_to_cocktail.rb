class AddPhotoToCocktail < ActiveRecord::Migration[5.0]
  def change
    add_column :cocktails, :photo, :string
  end
end
