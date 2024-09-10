require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'has a valid factory' do
    expect(build(:answer)).to be_valid
  end

  it { should belong_to(:question) }

  it { should validate_presence_of(:content) }
  it { should allow_value(true).for(:is_correct) }
  it { should allow_value(false).for(:is_correct) }
end
