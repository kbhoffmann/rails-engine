require 'rails_helper'

describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items}
  end

  describe 'class methods' do
    it 'can find a merchant by name' do
      merchant_1 = create(:merchant, name: "Store", id:1)
      merchant_2 = create(:merchant, name: "Stores", id:2)

      search = "Store"

      expect(Merchant.find_merchant_by_name(search).first.name).to eq("Store")
      expect(Merchant.find_merchant_by_name(search).first.id).to eq(1)
    end
  end
end
