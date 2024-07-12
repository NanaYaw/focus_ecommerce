require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should have_many(:orders) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe 'when email is not unique' do
    it 'is not valid' do
      duplicate_user = build(:user, email: subject.email.capitalize)
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end
end
