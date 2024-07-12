require 'rails_helper'

RSpec.describe Order, type: :model do
   it { should belong_to(:user) }
   it { should have_many(:product_lines) }
   it { should have_many(:products).through(:product_lines) } 

   it { should validate_presence_of(:user) }
end
