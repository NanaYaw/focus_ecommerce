require 'rails_helper'

RSpec.describe Session, type: :model do
  subject { build(:session) }

  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_presence_of(:user) }
end
