class RemoveApprovalFieldsFromAdmins < ActiveRecord::Migration[8.1]
  def change
    remove_column :admins, :status, :string
    remove_column :admins, :approval_token, :string
  end
end
