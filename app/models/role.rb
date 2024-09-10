class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, optional: true

  ALLOWED_NAMES = %w[admin manager].freeze

  validates :name, presence: true
  validates :name, inclusion: { in: ALLOWED_NAMES }
  validate :custom_name_validation

  scopify

  def self.allowed_role_names
    ALLOWED_NAMES
  end

  private

  def custom_name_validation
    return if ALLOWED_NAMES.include?(name)

    errors.add(:name, :custom_inclusion,
      message: I18n.t(
        "errors.messages.inclusion_with_value",
        value: name,
        allowed_values: ALLOWED_NAMES.join(", ")
      )
    )
  end
end
