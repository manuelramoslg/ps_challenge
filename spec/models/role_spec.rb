require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_inclusion_of(:name).in_array(Role::ALLOWED_NAMES) }

  it { should have_and_belong_to_many(:users) }
  it { should belong_to(:resource).optional }

  describe 'custom validations' do
    it 'is valid with an allowed name' do
      Role::ALLOWED_NAMES.each do |name|
        role = build(:role, name: name)
        expect(role).to be_valid
      end
    end

    it 'is not valid with a disallowed name' do
      role = build(:role, name: 'invalid_role')
      expect(role).not_to be_valid
      expected_message = I18n.t(
        "errors.messages.inclusion_with_value",
        value: 'invalid_role',
        allowed_values: Role::ALLOWED_NAMES.join(', ')
      )
      expect(role.errors[:name]).to include(expected_message)
    end
  end
end
