class AddDefaultStatus < ActiveRecord::Migration[7.0]
  def change
    change_column :invitations, :status, :integer, default: 0
  end
end
