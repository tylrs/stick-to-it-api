class CreateHabitPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :habit_plans do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :habit, null: false, foreign_key: true
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
