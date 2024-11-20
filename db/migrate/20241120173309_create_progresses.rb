class CreateProgresses < ActiveRecord::Migration[7.2]
  def change
    create_table :progresses do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :date, null: false
      t.string :status, null: false

      t.timestamps
    end

    # 同じ習慣・日付での重複を防ぐためにインデックスを追加
    add_index :progresses, [:habit_id, :date], unique: true
  end
end
