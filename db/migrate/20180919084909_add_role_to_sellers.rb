class AddRoleToSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :role, :string
  end
end
