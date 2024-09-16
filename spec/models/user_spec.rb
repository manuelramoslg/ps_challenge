# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_exams) }
    it { should have_many(:exams).through(:user_exams) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'creates an admin user' do
      admin = create(:user, :admin)
      expect(admin.has_role?(:admin)).to be true
    end

    it 'creates a manager user' do
      manager = create(:user, :manager)
      expect(manager.has_role?(:manager)).to be true
    end

    it 'creates a participant user' do
      participant = create(:user, :participant)
      expect(participant.has_role?(:participant)).to be true
    end
  end

  describe 'exams' do
    let(:user) { create(:user) }
    let(:exam) { create(:exam) }

    it 'can associate an exam with a user' do
      create(:user_exam, user: user, exam: exam)
      expect(user.exams).to include(exam)
    end

    it 'can retrieve user_exams for a user' do
      user_exam = create(:user_exam, user: user, exam: exam)
      expect(user.user_exams).to include(user_exam)
    end
  end
end
