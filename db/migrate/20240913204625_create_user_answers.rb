class CreateUserAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_answers do |t|
      t.references :user_exam, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :content
      t.boolean :is_correct
      t.integer :score

      t.timestamps
    end
  end
end
