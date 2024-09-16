# spec/models/user_exam_spec.rb
require 'rails_helper'

RSpec.describe UserExam, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:exam) }
    it { should have_many(:user_answers).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:user_exam) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:exam_id).with_message("has already taken this exam") }
    it { should validate_numericality_of(:total_score).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:user_answers) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user_exam)).to be_valid
    end

    it 'creates a user exam with associated user answers' do
      user_exam = create(:user_exam, :with_user_answers, user_answer_count: 3)
      expect(user_exam.user_answers.count).to eq(3)
    end

    it 'creates a user exam with a score' do
      user_exam = create(:user_exam, :with_score)
      expect(user_exam.total_score).to be_present
    end
  end

  describe '#calculate_score' do
    let(:exam) { create(:exam) }
    let(:user) { create(:user) }
    let(:user_exam) { create(:user_exam, user: user, exam: exam, total_score: nil) }

    context 'with free text questions' do
      it 'does not calculate score for free text questions' do
        # TODO Do something for free text questions
      end
    end

    context 'with multiple choice questions' do
      it 'calculates correct score for multiple choice questions' do
        question = create(:question, exam: exam, question_type: :multiple_choice, points: 5)
        correct_answers = create_list(:answer, 2, question: question, correct: true)

        expect(user_exam.calculate_score).to eq(0)

        create(:answer, question: question, correct: false)

        create(:user_answer, user_exam: user_exam, question: question, content: correct_answers.map(&:id).map(&:to_s))

        expect(user_exam.calculate_score).to eq(5)
      end
    end

    context 'with single choice questions' do
      it 'calculates correct score for single choice questions' do
        question = create(:question, exam: exam, question_type: :single_choice, points: 5)
        correct_answer = create(:answer, question: question, correct: true)

        expect(user_exam.calculate_score).to eq(0)

        create(:answer, question: question, correct: false)

        create(:user_answer, user_exam: user_exam, question: question, content: correct_answer.id.to_s)

        expect(user_exam.calculate_score).to eq(5)
      end
    end

    context 'with all type of questions' do
      it 'calculates correct score for all types of questions' do
        simple_question = create(:question, exam: exam, question_type: :single_choice, points: 5)
        multiple_question = create(:question, exam: exam, question_type: :multiple_choice, points: 5)

        correct_simple_answer = create(:answer, question: simple_question, correct: true)
        correct_multiple_answers = create_list(:answer, 2, question: multiple_question, correct: true)

        expect(user_exam.calculate_score).to eq(0)

        create(:answer, question: simple_question, correct: false)
        create(:answer, question: multiple_question, correct: false)

        create(:user_answer, user_exam: user_exam, question: simple_question, content: correct_simple_answer.id.to_s)
        create(:user_answer, user_exam: user_exam, question: multiple_question, content: correct_multiple_answers.map(&:id).map(&:to_s))

        expect(user_exam.calculate_score).to eq(10)
      end
    end
  end

  describe 'scopes' do
    let!(:completed_exam) { create(:user_exam, status: :completed, total_score: 10) }
    let!(:in_progress_exam) { create(:user_exam, status: :in_progress, total_score: nil) }

    it 'returns completed exams' do
      expect(UserExam.completed).to include(completed_exam)
      expect(UserExam.completed).not_to include(in_progress_exam)
    end

    it 'returns in_progress exams' do
      expect(UserExam.in_progress).to include(in_progress_exam)
      expect(UserExam.in_progress).not_to include(completed_exam)
    end
  end
end
