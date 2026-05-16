class AddStatusToAdmins < ActiveRecord::Migration[8.1]
  def change
    add_column :admins, :status, :string, null:false
  end
end
