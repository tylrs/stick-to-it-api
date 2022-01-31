class CreateUserHabits < ActiveRecord::Migration[7.0]
  def change
    create_table :user_habits do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :habit, null: false, foreign_key: true
      t.boolean :completed

      t.timestamps
    end
  end
end
