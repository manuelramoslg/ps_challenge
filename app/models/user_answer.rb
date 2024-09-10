class UserAnswer < ApplicationRecord
  belongs_to :exam_attempt
  belongs_to :question
  belongs_to :answer, optional: true

  validates :content, presence: true, if: -> { question&.free_text? }

  validate :answer_matches_question_type

  private

  def answer_matches_question_type
    return unless question
    if question.free_text? && answer.present?
      errors.add(:answer, "no debe estar presente para preguntas de texto libre")
    elsif !question.free_text? && answer.nil?
      errors.add(:answer, "debe estar presente para preguntas de selección")
    end
  end
end
