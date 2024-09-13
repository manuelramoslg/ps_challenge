class Question < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy
  has_many :user_answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  enum question_type: { free_text: 0, multiple_choice: 1, single_choice: 2 }

  validates :content, presence: true
  validates :question_type, presence: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
