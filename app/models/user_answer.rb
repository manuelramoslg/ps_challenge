class UserAnswer < ApplicationRecord
  belongs_to :user_exam
  belongs_to :question

  validates :content, presence: true

  def correct?
    case question.question_type
    when "free_text"
      # For free text questions, we could implement more complex logic
      # For now, we"ll assume that all free text responses are correct
      true
    when "multiple_choice"
      correct_answers = question.answers.where(correct: true).pluck(:id).map(&:to_s).sort
      user_answers = JSON.parse(content).sort
      correct_answers == user_answers
    when "single_choice"
      question.answers.find_by(id: content)&.correct?
    else
      false
    end
  end
end
