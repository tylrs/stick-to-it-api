class RenameUserIdColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :habits, :user_id, :creator_id
  end
end
