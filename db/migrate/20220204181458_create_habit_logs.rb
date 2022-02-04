class CreateHabitLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :habit_logs do |t|
      t.belongs_to :habit, null: false, foreign_key: true
      t.timestamp :scheduled_at
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
