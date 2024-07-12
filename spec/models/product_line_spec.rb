require 'rails_helper'

RSpec.describe ProductLine, type: :model do
  subject { create(:product_line) }  

  it { should belong_to(:order) } 
  it { should belong_to(:product) } 

  it { should validate_presence_of(:quantity) }
end


