class Exam < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :user_exams
  has_many :users, through: :user_exams
  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
