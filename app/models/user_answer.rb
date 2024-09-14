class UserAnswer < ApplicationRecord
  belongs_to :user_exam
  belongs_to :question

  validates :content, presence: true
end
