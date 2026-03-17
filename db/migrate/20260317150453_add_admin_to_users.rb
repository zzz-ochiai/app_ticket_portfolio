class AddAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    # defaultは新しいユーザーがadminでないことを保証し、null: falseはadminカラムが必ず値を持つことを保証します。
  end
end
