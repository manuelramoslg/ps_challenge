require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:exam) }
    it { should have_many(:answers).dependent(:destroy) }
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
  end
end
