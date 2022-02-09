require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "sends an array of data even when there are no merchants" do
    create_list(:merchant, 0)

    get '/api/v1/merchants'

    expect(response).to be_successful

    no_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(no_merchants.count).to eq(0)
    expect(no_merchants).to be_an(Array)
  end

  it "can get one merchant by its id" do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_data.count).to eq(1)
    expect(merchant_data[:data]).to have_key(:id)
    expect(merchant_data[:data]).to have_key(:attributes)
    expect(merchant_data[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:data][:attributes][:name]).to be_a(String)
    expect(merchant_data[:data][:attributes].length).to eq(1)
  end

  it "errors if a merchant does NOT exist" do
    merchant = create(:merchant)

    non_existant_id = merchant.id + 1

    get "/api/v1/merchants/#{non_existant_id}"

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(parsed_response).to have_key(:errors)
    expect(parsed_response[:errors]).to eq("Not Found")
  end

  it 'can get all of the merchants items' do
      merchant = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      item_3 = create(:item, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]

      merchant_items.each do |item|
        expect(item).to have_key(:id)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        # expect(item[:attributes][:merchant_id]).to be_a(Float)
      end
  end
end
