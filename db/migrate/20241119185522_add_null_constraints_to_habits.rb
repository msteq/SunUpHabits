class AddNullConstraintsToHabits < ActiveRecord::Migration[7.2]
  def change
    change_column_null :habits, :title, false
    change_column_null :habits, :goal, false
    change_column_null :habits, :start_date, false
  end
end
