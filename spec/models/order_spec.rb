require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { create(:order) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:product_lines) }
  it { is_expected.to have_many(:products).through(:product_lines) }
end
