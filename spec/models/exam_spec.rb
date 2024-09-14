# spec/models/exam_spec.rb
require 'rails_helper'

RSpec.describe Exam, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:user_exams) }
    it { should have_many(:users).through(:user_exams) }
    it { should accept_nested_attributes_for(:questions).allow_destroy(true) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe 'custom validations' do
    context 'end_date_after_start_date' do
      it 'is valid when end_date is after start_date' do
        exam = build(:exam, start_date: Date.today, end_date: Date.tomorrow)
        expect(exam).to be_valid
      end

      it 'is invalid when end_date is before start_date' do
        exam = build(:exam, start_date: Date.today, end_date: Date.yesterday)
        expect(exam).to be_invalid
        expect(exam.errors[:end_date]).to include(I18n.t('exam.errors.end_date_before_start_date'))
      end

      it 'is valid when start_date and end_date are the same' do
        exam = build(:exam, start_date: Date.today, end_date: Date.today)
        expect(exam).to be_valid
      end
    end
  end

  describe 'internationalization' do
    it 'uses the correct translation for end_date error' do
      exam = build(:exam, start_date: Date.today, end_date: Date.yesterday)
      exam.valid?
      expect(exam.errors[:end_date]).to include(I18n.t('exam.errors.end_date_before_start_date'))
    end

    it 'uses the correct translation for end_date error in Spanish' do
      I18n.with_locale(:es) do
        exam = build(:exam, start_date: Date.today, end_date: Date.yesterday)
        exam.valid?
        expect(exam.errors[:end_date]).to include(I18n.t('exam.errors.end_date_before_start_date'))
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:exam)).to be_valid
    end

    it 'creates an exam with associated questions' do
      exam = create(:exam, :with_questions, question_count: 3)
      expect(exam.questions.count).to eq(3)
    end
  end
end
