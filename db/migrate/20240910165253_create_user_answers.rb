class CreateUserAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :user_answers do |t|
      t.text :content
      t.references :exam_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
