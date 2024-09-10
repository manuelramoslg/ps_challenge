class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.text :content, null: false
      t.boolean :is_correct, default: false
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
