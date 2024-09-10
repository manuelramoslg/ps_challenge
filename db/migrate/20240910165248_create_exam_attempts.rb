class CreateExamAttempts < ActiveRecord::Migration[7.2]
  def change
    create_table :exam_attempts do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.float :score
      t.references :user, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true

      t.timestamps
    end
  end
end
