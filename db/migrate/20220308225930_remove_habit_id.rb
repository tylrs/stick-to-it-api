class RemoveHabitId < ActiveRecord::Migration[7.0]
  def change
    remove_column :habit_logs, :habit_id
  end
end
