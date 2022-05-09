class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.bigint :sender_id, null: false
      t.bigint :recipient_id, null: false
      t.string :recipient_email, null: false
      t.belongs_to :habit_plan, null: false
      t.integer :status

      t.timestamps
    end
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_id
    add_foreign_key :invitations, :users, column: "sender_id"
    add_foreign_key :invitations, :users, column: "recipient_id"
    add_foreign_key :invitations, :habit_plans
  end
end
