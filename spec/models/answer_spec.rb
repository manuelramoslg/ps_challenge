require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should allow_value(true).for(:correct) }
    it { should allow_value(false).for(:correct) }
    it { should_not allow_value(nil).for(:correct) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:answer)).to be_valid
    end
  end
end
