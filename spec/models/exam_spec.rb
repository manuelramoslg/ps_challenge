require 'rails_helper'

RSpec.describe Exam, type: :model do
  it 'has a valid factory' do
    expect(build(:exam)).to be_valid
  end

  it { should have_many(:questions) }
  it { should have_many(:exam_attempts) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }

  describe '.active' do
    let!(:past_exam) { create(:exam, start_date: 2.days.ago, end_date: 1.day.ago) }
    let!(:current_exam) { create(:exam, start_date: 1.day.ago, end_date: 1.day.from_now) }
    let!(:future_exam) { create(:exam, start_date: 1.day.from_now, end_date: 2.days.from_now) }

    it 'returns only active exams' do
      expect(Exam.active).to include(current_exam)
      expect(Exam.active).not_to include(past_exam, future_exam)
    end
  end
end
