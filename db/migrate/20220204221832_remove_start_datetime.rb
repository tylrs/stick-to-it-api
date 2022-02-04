class RemoveStartDatetime < ActiveRecord::Migration[7.0]
  def up
    remove_column :habits, :start_datetime
  end

  def down
    add_column :habits, :start_datetime, :datetime
  end  
end
