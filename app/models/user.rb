class User < ApplicationRecord
  rolify
  has_many :user_roles
  has_many :user_exams
  has_many :exams, through: :user_exams

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
end
