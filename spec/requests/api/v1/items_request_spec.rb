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

  it "sends an array of data even when there are no items" do
    create_list(:item, 0)

    get '/api/v1/items'

    expect(response).to be_successful

    no_items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(no_items.count).to eq(0)
    expect(no_items).to be_an(Array)
  end

  it "can get one item by its id" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item_1.id}"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_data.count).to eq(1)

    expect(item_data[:data]).to have_key(:id)

    expect(item_data[:data][:attributes]).to have_key(:name)
    expect(item_data[:data][:attributes][:name]).to be_a(String)

    expect(item_data[:data][:attributes]).to have_key(:description)
    expect(item_data[:data][:attributes][:description]).to be_a(String)

    expect(item_data[:data][:attributes]).to have_key(:unit_price)
    expect(item_data[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item_data[:data][:attributes]).to have_key(:merchant_id)
    expect(item_data[:data][:attributes][:merchant_id]).to be_an(Integer)

    expect(item_data[:data][:attributes].length).to eq(4)
  end

  it "errors if a item does NOT exist" do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)
    non_existant_id = item_1.id + 1

    get "/api/v1/items/#{non_existant_id}"

    # parsed_response = JSON.parse(response.body, symbolize_names: true)
    # ---->   uncomment if needing to see detailed error

    expect(response.status).to eq(404)
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

     new_item = JSON.parse(response.body, symbolize_names: true)[:data]

     expect(response).to be_successful

     expect(new_item[:attributes]).to have_key(:name)
     expect(new_item[:attributes][:name]).to be_a(String)
     expect(new_item[:attributes][:name]).to eq("New Item")

     expect(new_item[:attributes]).to have_key(:description)
     expect(new_item[:attributes][:description]).to be_a(String)
     expect(new_item[:attributes][:description]).to eq("This Item is New to the DB")

     expect(new_item[:attributes]).to have_key(:unit_price)
     expect(new_item[:attributes][:unit_price]).to be_a(Float)
     expect(new_item[:attributes][:unit_price]).to eq(9.27)

     expect(new_item[:attributes]).to have_key(:merchant_id)
     expect(new_item[:attributes][:merchant_id]).to be_an(Integer)
     expect(new_item[:attributes][:merchant_id]).to eq(merchant.id)

     expect(response.status).to eq(201)
  end

  it 'ignores unallowed attributes' do
    merchant = create(:merchant)

    item_params = ({
                    name: "New Item",
                    description: "This Item is New to the DB",
                    unit_price: 9.27,
                    color: "green",
                    merchant_id: merchant.id
                  })
                  headers = {"CONTENT_TYPE" => "application/json"}

     post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

     new_item = JSON.parse(response.body, symbolize_names: true)[:data]

     expect(response).to be_successful

     expect(new_item[:attributes]).to have_key(:name)
     expect(new_item[:attributes][:name]).to be_a(String)
     expect(new_item[:attributes][:name]).to eq("New Item")

     expect(new_item[:attributes]).to have_key(:description)
     expect(new_item[:attributes][:description]).to be_a(String)
     expect(new_item[:attributes][:description]).to eq("This Item is New to the DB")

     expect(new_item[:attributes]).to have_key(:unit_price)
     expect(new_item[:attributes][:unit_price]).to be_a(Float)
     expect(new_item[:attributes][:unit_price]).to eq(9.27)

     expect(new_item[:attributes]).to have_key(:merchant_id)
     expect(new_item[:attributes][:merchant_id]).to be_an(Integer)
     expect(new_item[:attributes][:merchant_id]).to eq(merchant.id)

     expect(new_item[:attributes]).to_not have_key(:color)
     expect(response.status).to eq(201)
  end

  it 'shows an error if an attribute is missing' do
    merchant = create(:merchant)

    item_params = ({
                    name: "New Item",
                    unit_price: 9.27,
                    merchant_id: merchant.id
                  })
                  headers = {"CONTENT_TYPE" => "application/json"}

     post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

     #works without parsing, still need to parse the response?????
     #just need to parse to see the errors???
     # JSON.parse(response.body, symbolize_names: true)[:data]

     # expect(response).to_not be_successful
     expect(response.status).to eq(400)
  end

  it 'can edit an existing item' do
    item = create(:item)

    item_params = { name: "Updated Name",
                    description: "Updated description",
                    unit_price: 4.26,
                  }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

    updated_item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(updated_item[:attributes]).to have_key(:name)
    expect(updated_item[:attributes][:name]).to be_a(String)
    expect(updated_item[:attributes][:name]).to eq("Updated Name")

    expect(updated_item[:attributes]).to have_key(:description)
    expect(updated_item[:attributes][:description]).to be_a(String)
    expect(updated_item[:attributes][:description]).to eq("Updated description")

    expect(updated_item[:attributes]).to have_key(:unit_price)
    expect(updated_item[:attributes][:unit_price]).to be_a(Float)
    expect(updated_item[:attributes][:unit_price]).to eq(4.26)

    expect(updated_item[:attributes]).to have_key(:merchant_id)
    expect(updated_item[:attributes][:merchant_id]).to be_an(Integer)
    expect(updated_item[:attributes][:merchant_id]).to eq(item.merchant_id)
  end

  it 'raises an error if the merchant does not exist' do
    item = create(:item)
    item_params = { merchant_id: 0 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response.status).to eq(400)
  end

  it 'can delete an item' do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)
    item_2 = create(:item, merchant_id: merchant.id)
    item_3 = create(:item, merchant_id: merchant.id)

    expect(Item.count).to eq(3)

    delete "/api/v1/items/#{item_3.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(2)
    expect{ delete "/api/v1/items/#{item_2.id}"}.to change(Item, :count).by(-1)
    expect{Item.find(item_3.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(Item.count).to eq(1)
    expect{Item.find(item_2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(response.status).to eq(204)
  end

  it 'returns a 404 error if the item is not found' do
    merchant = create(:merchant)
    item_1 = create(:item, merchant_id: merchant.id)

    delete "/api/v1/items/#{item_1.id + 1}"

    expect(response.status).to eq(404)
  end

  it 'can get the merchant data for a given item ID' do
    merchant = create(:merchant, name: "The Store")

    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to eq("The Store")
    expect(merchant[:attributes][:name]).to be_a(String)
  end
end
