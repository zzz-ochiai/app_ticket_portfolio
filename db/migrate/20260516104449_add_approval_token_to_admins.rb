class AddApprovalTokenToAdmins < ActiveRecord::Migration[8.1]
  def change
    add_column :admins, :approval_token, :string
  end
end
