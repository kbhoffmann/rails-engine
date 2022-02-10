require 'rails_helper'

describe 'All Items Search API endpoint' do
  it 'returns all items that match name search' do
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

    search = "name=ring"
    get "/api/v1/items/find_all?#{search}"

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(items.length).to eq(6)

    items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes].length).to eq(4)
    end
  end

  it 'returns all items that match min price search' do
    merchant_1 = create(:merchant)
    item_1 = merchant_1.items.create!(name: "Item 1 Name", description: "Item 1 Description", unit_price: 50)
    item_2 = merchant_1.items.create!(name: "Item 2 Name", description: "Item 2 Description", unit_price: 25)
    item_3 = merchant_1.items.create!(name: "Item 3 Name", description: "Item 3 Description", unit_price: 30)
    item_4 = merchant_1.items.create!(name: "Item 4 Name", description: "Item 4 Description", unit_price: 175)
    merchant_2 = create(:merchant)
    item_5 = merchant_2.items.create!(name: "Item 5 Name", description: "Item 5 Description", unit_price: 155)
    item_6 = merchant_2.items.create!(name: "Item 6 Name", description: "Item 6 Description", unit_price: 40)
    item_7 = merchant_2.items.create!(name: "Item 7 Name", description: "Item 7 Description", unit_price: 200)
    merchant_3 = create(:merchant)
    item_8 = merchant_2.items.create!(name: "Item 8 Name", description: "Item 8 Description", unit_price: 300)
    item_9 = merchant_2.items.create!(name: "Item 9 Name", description: "Item 9 Description", unit_price: 50)
    item_10 = merchant_2.items.create!(name: "Item 10 Name", description: "Item 9 Description", unit_price: 10)
    # GET /api/v1/items/find_all?min_price=50
    search = "min_price=50"
    get "/api/v1/items/find_all?#{search}"
    # search = "min_price=50"
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(items.length).to eq(6)

    items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes].length).to eq(4)
    end
  end

  xit 'returns all itmes that match max price search' do
    # GET /api/v1/items/find_all?max_price=150
    # search = "max_price=150"
    search = "max_price=150"

    get "/api/vi/items/find_all?#{search}"

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(items.length).to eq()

    items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes].length).to eq(4)
    end
  end

  xit 'returns all items that match min and max price search' do
    # GET /api/v1/items/find_all?max_price=150&min_price=50
    # search = "max_price=150&min_price=50"
    search = "max_price=150&min_price=50"
    get "/api/vi/items/find_all?#{search}"

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(items.length).to eq()

    items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes].length).to eq(4)
    end
  end

  xit 'returns nil if an item does not exist' do
    # merchant_1 = create(:merchant, name: "ABC")
    # merchant_2 = create(:merchant, name: "DEF")

    search = "XYZ"

    get "/api/v1/items/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_search).to have_key(:data)
    expect(parsed_search[:data][:message]).to eq("No items match your search")
    #change message and the parsed_search variable in merchant
  end
end
