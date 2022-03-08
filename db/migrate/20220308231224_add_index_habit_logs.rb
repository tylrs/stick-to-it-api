class AddIndexHabitLogs < ActiveRecord::Migration[7.0]
  def change
    add_index :habit_logs, :habit_plan_id
  end
end
