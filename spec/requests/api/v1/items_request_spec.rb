require 'rails_helper'

describe 'Items API' do
  it "it sends a list of all items" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    item_3 = create(:item, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item_1.id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(item).to have_key(:id)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)

    expect(item[:attributes].length).to eq(4)
  end

  it "errors if a item does NOT exist" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)
    non_existant_id = item_1.id + 1

    get "/api/v1/items/#{non_existant_id}"

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed_response).to have_key(:errors)
    expect(parsed_response[:errors]).to eq("Not Found")
  end

  it 'can create an item' do
    merchant = create(:merchant)

    item_params = ({
                    name: "New Item",
                    description: "This Item is New to the DB",
                    unit_price: 9.27,
                    merchant_id: merchant.id
                  })
                  headers = {"CONTENT_TYPE" => "application/json"}

     post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

     new_item = Item.last

     expect(response).to be_successful
     expect(new_item.name).to eq(item_params[:name])
     expect(new_item.description).to eq(item_params[:description])
     expect(new_item.unit_price).to eq(item_params[:unit_price])
     expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  xit 'can edit an item' do
    
  end

  xit 'can delete an item' do
  end

  xit 'can get the merchant data for a given item ID' do
  end
end