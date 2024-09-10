require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end

  it { should belong_to(:exam) }
  it { should have_many(:answers) }
  it { should have_many(:user_answers) }

  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:question_type) }
  it { should define_enum_for(:question_type).with_values([ :free_text, :multiple_choice, :single_choice ]) }

  context 'when is_scorable is true' do
    before { allow(subject).to receive(:is_scorable?).and_return(true) }
    it { should validate_presence_of(:points) }
  end

  context 'when is_scorable is false' do
    before { allow(subject).to receive(:is_scorable?).and_return(false) }
    it { should_not validate_presence_of(:points) }
  end
end
