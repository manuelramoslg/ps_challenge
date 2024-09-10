class Exam < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :exam_attempts, dependent: :destroy

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :active, -> { where("start_date <= ? AND end_date >= ?", Time.current, Time.current) }
end
