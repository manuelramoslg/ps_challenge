require 'rails_helper'

RSpec.describe ExamAttempt, type: :model do
  it 'has a valid factory' do
    expect(build(:exam_attempt)).to be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:exam) }
  it { should have_many(:user_answers) }

  it { should validate_presence_of(:start_time) }
  it { should validate_numericality_of(:score).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100).allow_nil }

  context 'when completed' do
    before { allow(subject).to receive(:completed?).and_return(true) }
    it { should validate_presence_of(:end_time) }
  end

  context 'when not completed' do
    before { allow(subject).to receive(:completed?).and_return(false) }
    it { should_not validate_presence_of(:end_time) }
  end

  describe '#calculate_score' do
    let(:exam) { create(:exam) }
    let(:user) { create(:user) }
    let(:exam_attempt) { create(:exam_attempt, exam: exam, user: user, score: nil) }
    let!(:question1) { create(:question, :multiple_choice, exam: exam, is_scorable: true, points: 5) }
    let!(:question2) { create(:question, :multiple_choice, exam: exam, is_scorable: true, points: 5) }
    let!(:correct_answer1) { create(:answer, question: question1, is_correct: true) }
    let!(:incorrect_answer1) { create(:answer, question: question1, is_correct: false) }
    let!(:correct_answer2) { create(:answer, question: question2, is_correct: true) }
    let!(:incorrect_answer2) { create(:answer, question: question2, is_correct: false) }

    before do
      create(:user_answer, exam_attempt: exam_attempt, question: question1, answer: correct_answer1)
      create(:user_answer, exam_attempt: exam_attempt, question: question2, answer: incorrect_answer2)
    end

    it 'calculates the correct score' do
      exam_attempt.calculate_score
      expect(exam_attempt.score).to eq(50.0)
    end
  end
end
