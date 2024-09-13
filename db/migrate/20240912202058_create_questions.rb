class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :question_type, null: false, default: 0
      t.integer :points
      t.boolean :evaluable, default: true

      t.timestamps
    end
  end
end
