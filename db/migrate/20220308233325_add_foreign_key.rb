class AddForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :habit_logs, :habit_plans
  end
end
