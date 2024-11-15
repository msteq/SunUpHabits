class AddNullFalseToUsersName < ActiveRecord::Migration[7.2]
  def change
    # `name`カラムに`null: false`を追加
    change_column_null :users, :name, false
  end
end
