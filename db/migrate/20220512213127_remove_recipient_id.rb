class RemoveRecipientId < ActiveRecord::Migration[7.0]
  def change
    remove_index :invitations, column: :recipient_id
    remove_foreign_key :invitations, column: :recipient_id
    remove_column :invitations, :recipient_id
  end
end
