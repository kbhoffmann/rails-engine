require 'rails_helper'

describe 'All Items Search API endpoint' do
  it 'returns all items that match name search' do
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create!(name: "Rings", description: "Item 1 Description", unit_price: 200)
    item_2 = merchant_1.items.create!(name: "Titanium ring", description: "Item 2 Description", unit_price: 300)
    item_3 = merchant_1.items.create!(name: "Manufacturing Product", description: "Item 3 Description", unit_price: 1000)
    merchant_2 = create(:merchant)
    item_4 = merchant_2.items.create!(name: "Loud Ringing Bell", description: "Item 4 Description", unit_price: 500)
    item_5 = merchant_2.items.create!(name: "Stringy mop", description: "Item 5 Description", unit_price: 400)
    item_5 = merchant_2.items.create!(name: "string thing", description: "Item 5 Description", unit_price: 100)
  
    search = "name=ring"
    get "/api/v1/items/find_all?#{search}"

    items = JSON.parse(response.body, symbolize_names: true)
  end

  xit 'returns all items that match min price search' do
    # GET /api/v1/items/find_all?min_price=50
    # search = "min_price=50"
  end

  xit 'returns all itmes that match max price search' do
    # GET /api/v1/items/find_all?max_price=150
    # search = "max_price=150"
  end

  xit 'returns all items that match min and max price search' do
    # GET /api/v1/items/find_all?max_price=150&min_price=50
    # search = "max_price=150&min_price=50"
  end

  xit 'returns nil if an item does not exist' do
    # merchant_1 = create(:merchant, name: "ABC")
    # merchant_2 = create(:merchant, name: "DEF")
    # search = "XYZ"

    get "/api/v1/items/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_search).to have_key(:data)
    expect(parsed_search[:data][:message]).to eq("No items match your search")
    #change message and the parsed_search variable in merchant
  end
end
