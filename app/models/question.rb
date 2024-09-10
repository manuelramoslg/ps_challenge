class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy
  has_many :user_answers

  enum question_type: { free_text: 0, multiple_choice: 1, single_choice: 2 }

  validates :content, presence: true
  validates :question_type, presence: true
  validates :points, presence: true, if: :is_scorable?
end
