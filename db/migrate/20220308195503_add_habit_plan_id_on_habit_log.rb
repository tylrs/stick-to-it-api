class AddHabitPlanIdOnHabitLog < ActiveRecord::Migration[7.0]
  def change
    add_column :habit_logs, :habit_plan_id, :bigint
  end
end
