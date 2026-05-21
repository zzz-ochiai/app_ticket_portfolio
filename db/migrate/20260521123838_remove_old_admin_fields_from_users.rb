class RemoveOldAdminFieldsFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :admin, :boolean
    remove_column :users, :admin_approval_token, :string
    remove_column :users, :admin_approved, :boolean
    remove_column :users, :admin_requested, :boolean
  end
end
