# spec/models/user_answer_spec.rb
require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  it { should belong_to(:exam_attempt) }
  it { should belong_to(:question) }
  it { should belong_to(:answer).optional }

  describe 'validations' do
    let(:question) { instance_double("Question") }

    before do
      allow(subject).to receive(:question).and_return(question)
      allow(question).to receive(:marked_for_destruction?).and_return(false)
    end

    context 'when question is free text' do
      before do
        allow(question).to receive(:free_text?).and_return(true)
      end

      it { should validate_presence_of(:content) }
    end

    context 'when question is not free text' do
      before do
        allow(question).to receive(:free_text?).and_return(false)
      end

      it { should_not validate_presence_of(:content) }
    end
  end

  describe '#answer_matches_question_type' do
    let(:user_answer) { build(:user_answer) }
    let(:question) { user_answer.question }

    context 'when question is free text' do
      before do
        allow(question).to receive(:free_text?).and_return(true)
      end

      it 'adds an error if answer is present' do
        user_answer.answer = build(:answer)
        user_answer.valid?
        expect(user_answer.errors[:answer]).to include("no debe estar presente para preguntas de texto libre")
      end
    end

    context 'when question is not free text' do
      before do
        allow(question).to receive(:free_text?).and_return(false)
      end

      it 'adds an error if answer is nil' do
        user_answer.answer = nil
        user_answer.valid?
        expect(user_answer.errors[:answer]).to include("debe estar presente para preguntas de selección")
      end
    end
  end
end
