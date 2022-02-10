require 'rails_helper'

describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items}
  end

  describe 'class methods' do
    it 'can return 1 merchant by name, case sensitive' do
      merchant_1 = create(:merchant, name: "Turing", id:1)
      merchant_2 = create(:merchant, name: "Ring World", id:2)

      search = "Rin"

      expect(Merchant.find_merchant_by_name(search).first.name).to eq("Ring World")
      expect(Merchant.find_merchant_by_name(search).first.id).to eq(2)
      expect(Merchant.find_merchant_by_name(search).length).to eq(1)
    end
  end
end
