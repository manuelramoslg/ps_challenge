# spec/models/user_answer_spec.rb
require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  describe 'associations' do
    it { should belong_to(:user_exam) }
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user_answer)).to be_valid
    end
  end

  describe 'content format' do
    it 'allows string content for free text questions' do
      question = create(:question, question_type: :free_text)
      user_answer = build(:user_answer, question: question, content: 'This is a free text answer')
      expect(user_answer).to be_valid
    end

    it 'allows array content for multiple choice questions' do
      question = create(:question, question_type: :multiple_choice)
      user_answer = build(:user_answer, question: question, content: [ '1', '2', '3' ])
      expect(user_answer).to be_valid
    end

    it 'allows string content for single choice questions' do
      question = create(:question, question_type: :single_choice)
      user_answer = build(:user_answer, question: question, content: '1')
      expect(user_answer).to be_valid
    end
  end
end
