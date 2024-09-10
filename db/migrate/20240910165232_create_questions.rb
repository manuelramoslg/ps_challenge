class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.integer :question_type, null: false
      t.boolean :is_scorable, default: true
      t.integer :points, default: 0
      t.references :exam, null: false, foreign_key: true

      t.timestamps
    end
  end
end
