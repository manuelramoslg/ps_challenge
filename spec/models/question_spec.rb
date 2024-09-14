require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:exam) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:user_answers) }
    it { should accept_nested_attributes_for(:answers).allow_destroy(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:question_type) }
    it { should validate_numericality_of(:points).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'enums' do
    it { should define_enum_for(:question_type).with_values(free_text: 0, multiple_choice: 1, single_choice: 2) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:question)).to be_valid
    end

    it 'creates a question with a specific type' do
      question = create(:question, question_type: :multiple_choice)
      expect(question.multiple_choice?).to be true
    end

    it 'creates a question with associated answers' do
      question = create(:question, :with_answers, answer_count: 4)
      expect(question.answers.count).to eq(4)
    end
  end

  describe 'scopes' do
    before do
      create(:question, question_type: :free_text)
      create(:question, question_type: :multiple_choice)
      create(:question, question_type: :single_choice)
    end

    it 'returns free text questions' do
      expect(Question.free_text.count).to eq(1)
    end

    it 'returns multiple choice questions' do
      expect(Question.multiple_choice.count).to eq(1)
    end

    it 'returns single choice questions' do
      expect(Question.single_choice.count).to eq(1)
    end
  end
end
