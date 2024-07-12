require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { create(:product) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:stock) }

  describe 'validations' do
    it 'creates with a valid price' do
      product = create(:product)
      expect(product.price).to be_a(Integer)
      expect(product.price).to be > 0
    end

    it 'creates products with sequential whole numbers' do
      product = create(:product, price: 100)
      expect(product.price).to eq(100)
    end

    it 'creates products with sequential decimal prices and saves as integers' do
      product = create(:product, price: 1 * 1.25)
      expect(product.price).to eq(125)
    end
  end
end
