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
      item_8 = merchant_3.items.create!(name: "NOPE 3", description: "Item 8 Description", unit_price: 100)
      item_9 = merchant_3.items.create!(name: "string thing", description: "Item 9 Description", unit_price: 100)

      name = "ring"

      expect(Item.find_all_items_by_name(name).length).to eq(6)
    end

    it 'can find all items by minimum price search' do
      merchant_1 = create(:merchant)
      item_1 = merchant_1.items.create!(name: "Item 1 Name", description: "Item 1 Description", unit_price: 50)
      item_2 = merchant_1.items.create!(name: "Item 2 Name", description: "Item 2 Description", unit_price: 25)
      item_3 = merchant_1.items.create!(name: "Item 3 Name", description: "Item 3 Description", unit_price: 30)
      item_4 = merchant_1.items.create!(name: "Item 4 Name", description: "Item 4 Description", unit_price: 175)
      merchant_2 = create(:merchant)
      item_5 = merchant_2.items.create!(name: "Item 5 Name", description: "Item 5 Description", unit_price: 150)
      item_6 = merchant_2.items.create!(name: "Item 6 Name", description: "Item 6 Description", unit_price: 40)
      item_7 = merchant_2.items.create!(name: "Item 7 Name", description: "Item 7 Description", unit_price: 200)
      merchant_3 = create(:merchant)
      item_8 = merchant_3.items.create!(name: "Item 8 Name", description: "Item 8 Description", unit_price: 300)
      item_9 = merchant_3.items.create!(name: "Item 9 Name", description: "Item 9 Description", unit_price: 50)
      item_10 = merchant_3.items.create!(name: "Item 10 Name", description: "Item 9 Description", unit_price: 10)

      min_price = 50

      expect(Item.find_all_items_by_min_price(min_price).length).to eq(6)
    end

    it 'can find all items by maximum price search' do
      merchant_1 = create(:merchant)
      item_1 = merchant_1.items.create!(name: "Item 1 Name", description: "Item 1 Description", unit_price: 50)
      item_2 = merchant_1.items.create!(name: "Item 2 Name", description: "Item 2 Description", unit_price: 25)
      item_3 = merchant_1.items.create!(name: "Item 3 Name", description: "Item 3 Description", unit_price: 30)
      item_4 = merchant_1.items.create!(name: "Item 4 Name", description: "Item 4 Description", unit_price: 175)
      merchant_2 = create(:merchant)
      item_5 = merchant_2.items.create!(name: "Item 5 Name", description: "Item 5 Description", unit_price: 150)
      item_6 = merchant_2.items.create!(name: "Item 6 Name", description: "Item 6 Description", unit_price: 40)
      item_7 = merchant_2.items.create!(name: "Item 7 Name", description: "Item 7 Description", unit_price: 200)
      merchant_3 = create(:merchant)
      item_8 = merchant_3.items.create!(name: "Item 8 Name", description: "Item 8 Description", unit_price: 300)
      item_9 = merchant_3.items.create!(name: "Item 9 Name", description: "Item 9 Description", unit_price: 50)
      item_10 = merchant_3.items.create!(name: "Item 10 Name", description: "Item 9 Description", unit_price: 10)

      max_price = 150

      expect(Item.find_all_items_by_max_price(max_price).length).to eq(7)
    end

    it 'can find all items within a price range' do
      merchant_1 = create(:merchant)
      item_1 = merchant_1.items.create!(name: "Item 1 Name", description: "Item 1 Description", unit_price: 50)
      item_2 = merchant_1.items.create!(name: "Item 2 Name", description: "Item 2 Description", unit_price: 25)
      item_3 = merchant_1.items.create!(name: "Item 3 Name", description: "Item 3 Description", unit_price: 30)
      item_4 = merchant_1.items.create!(name: "Item 4 Name", description: "Item 4 Description", unit_price: 175)
      merchant_2 = create(:merchant)
      item_5 = merchant_2.items.create!(name: "Item 5 Name", description: "Item 5 Description", unit_price: 150)
      item_6 = merchant_2.items.create!(name: "Item 6 Name", description: "Item 6 Description", unit_price: 40)
      item_7 = merchant_2.items.create!(name: "Item 7 Name", description: "Item 7 Description", unit_price: 200)
      merchant_3 = create(:merchant)
      item_8 = merchant_3.items.create!(name: "Item 8 Name", description: "Item 8 Description", unit_price: 300)
      item_9 = merchant_3.items.create!(name: "Item 9 Name", description: "Item 9 Description", unit_price: 50)
      item_10 = merchant_3.items.create!(name: "Item 10 Name", description: "Item 10 Description", unit_price: 10)
      item_11 = merchant_3.items.create!(name: "Item 11 Name", description: "Item 11 Description", unit_price: 100)

      min_price = 50
      max_price = 150

      expect(Item.find_all_items_by_price_range(min_price, max_price).length).to eq(4)
    end
  end
end
