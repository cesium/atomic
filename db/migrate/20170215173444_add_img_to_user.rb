class AddImgToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :image, :string
  end
end
