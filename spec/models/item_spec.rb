require 'rails_helper'

describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'class methods' do
    it 'can find all items by name, case insensitive' do
      #change to case insensitive in merchant_spec
      merchant_1 = create(:merchant)
      item_1 = merchant_1.items.create!(name: "Rings", description: "Item 1 Description", unit_price: 200)
      item_2 = merchant_1.items.create!(name: "Titanium ring", description: "Item 2 Description", unit_price: 300)
      item_3 = merchant_1.items.create!(name: "NOPE 1", description: "Item 3 Description", unit_price: 300)
      item_4 = merchant_1.items.create!(name: "Manufacturing Product", description: "Item 4 Description", unit_price: 1000)
      merchant_2 = create(:merchant)
      item_5 = merchant_2.items.create!(name: "Loud Ringing Bell", description: "Item 5 Description", unit_price: 500)
      item_6 = merchant_2.items.create!(name: "Stringy mop", description: "Item 6 Description", unit_price: 400)
      item_7 = merchant_2.items.create!(name: "NOPE 2", description: "Item 7 Description", unit_price: 400)
      merchant_3 = create(:merchant)
      item_8 = merchant_2.items.create!(name: "NOPE 3", description: "Item 8 Description", unit_price: 100)
      item_9 = merchant_2.items.create!(name: "string thing", description: "Item 9 Description", unit_price: 100)

      search = "ring"

      expect(Item.find_all_items_by_name(search).length).to eq(6)
    end
  end
end


# GET /api/v1/items/find_all?min_price=50
# search = "min_price=50"
# GET /api/v1/items/find_all?max_price=150
# search = "max_price=150"
# GET /api/v1/items/find_all?max_price=150&min_price=50
# search = "max_price=150&min_price=50"
