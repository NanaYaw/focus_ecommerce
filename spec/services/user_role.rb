require 'rails_helper'

RSpec.describe UserRole, type: :model do
  describe '#initialize' do
    context 'with valid role' do
      it 'assigns the role' do
        user_role = UserRole.new('admin')
        expect(user_role.role).to eq('admin')
      end
    end

    context 'with invalid role' do
      it 'assigns default role of user' do
        user_role = UserRole.new('invalid_role')
        expect(user_role.role).to eq('user')
      end
    end
  end

  describe '#==' do
    it 'returns true for equal roles' do
      admin_role1 = UserRole.new('admin')
      admin_role2 = UserRole.new('admin')
      expect(admin_role1).to eq(admin_role2)
    end

    it 'returns false for different roles' do
      admin_role = UserRole.new('admin')
      user_role = UserRole.new('user')
      expect(admin_role).not_to eq(user_role)
    end
  end

  describe '.to_select' do
    it 'returns all roles' do
      expect(UserRole.to_select).to eq(%w[admin user])
    end
  end

  describe '#admin?' do
    it 'returns true for admin role' do
      admin_role = UserRole.new('admin')
      expect(admin_role.admin?).to be true
    end

    it 'returns false for user role' do
      user_role = UserRole.new('user')
      expect(user_role.admin?).to be false
    end
  end

  describe '#user?' do
    it 'returns true for user role' do
      user_role = UserRole.new('user')
      expect(user_role.user?).to be true
    end

    it 'returns false for admin role' do
      admin_role = UserRole.new('admin')
      expect(admin_role.user?).to be false
    end
  end

  describe '#to_s' do
    it 'returns capitalized role' do
      admin_role = UserRole.new('admin')
      expect(admin_role.to_s).to eq('Admin')
    end
  end
end
