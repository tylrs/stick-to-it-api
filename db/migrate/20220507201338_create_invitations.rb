class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.bigint :recipient_id
      t.string :recipient_email, null: false
      t.belongs_to :habit_plan, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
    add_index :invitations, :recipient_email
  end
end
