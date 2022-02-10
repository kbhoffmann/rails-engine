require 'rails_helper'

describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items}
  end

  describe 'class methods' do
    it 'can find a merchant by name' do
      merchant_1 = create(:merchant, name: "Burt's Store", id:1)
      merchant_2 = create(:merchant, name: "Burt's Bazaar", id:2)

      search = "Bur"

      expect(Merchant.find_merchant_by_name(search).first.name).to eq("Burt's Store")
      expect(Merchant.find_merchant_by_name(search).first.id).to eq(1)
      expect(Merchant.find_merchant_by_name(search).length).to eq(1)
    end
  end
end
