class UserRole
  ROLES = %w[admin user].freeze

  attr_reader :role

  def initialize(role)
    @role = role
  end

  def role
    ROLES[role]
  end

  def ==(other)
    role == other.role
  end

  class << self
    def to_select
      ROLES.map { |role| role }
    end
  end

  def admin?
    ROLES.include?(role)
  end

  def user?
    ROLES.include?(role)
  end

  def to_s
    role.capitalize
  end
end
