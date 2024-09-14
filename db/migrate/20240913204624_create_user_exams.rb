class CreateUserExams < ActiveRecord::Migration[6.1]
  def change
    create_table :user_exams do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.integer :total_score

      t.timestamps
    end

    add_index :user_exams, [ :user_id, :exam_id ], unique: true
  end
end
