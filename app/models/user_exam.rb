# app/models/user_exam.rb
class UserExam < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  has_many :user_answers, dependent: :destroy

  accepts_nested_attributes_for :user_answers

  validates :user_id, uniqueness: { scope: :exam_id, message: "has already taken this exam" }
  validates :total_score, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :completed, -> { where.not(total_score: nil) }
  scope :incomplete, -> { where(total_score: nil) }

  def calculate_score
    total_points = 0
    self.user_answers.includes(question: :answers).each do |user_answer|
      question = user_answer.question
      case question.question_type
      when "free_text"
        # Do something for free text questions
      when "multiple_choice"
        correct_answers = question.answers.where(correct: true).pluck(:id).map(&:to_s)
        user_answers = JSON.parse(user_answer.content).sort
        if correct_answers == user_answers
          total_points += question.points.to_i
        end
      when "single_choice"
        if question.answers.find_by(id: user_answer.content)&.correct?
          total_points += question.points.to_i
        end
      end
    end
    update(total_score: total_points)
    total_points
  end
end
