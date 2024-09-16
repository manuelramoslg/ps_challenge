class AddStatusToUserExams < ActiveRecord::Migration[7.2]
  def change
    add_column :user_exams, :status, :integer, default: 1, null: false
    add_index :user_exams, :status
  end
end
