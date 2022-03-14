class ChangeNullHabitPlanId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :habit_logs, :habit_plan_id, false
  end
end
