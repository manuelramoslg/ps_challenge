class ExamAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :exam
  has_many :user_answers, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true, if: :completed?
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  def calculate_score
    total_points = exam.questions.where(is_scorable: true).sum(:points)
    earned_points = user_answers.joins(:question).where(questions: { is_scorable: true }).sum do |user_answer|
      if user_answer.answer&.is_correct?
        user_answer.question.points
      else
        0
      end
    end
    self.score = total_points > 0 ? (earned_points.to_f / total_points) * 100 : 0
    save
  end

  def completed?
    end_time.present?
  end
end
