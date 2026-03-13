class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.string :title
      t.boolean :used
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
