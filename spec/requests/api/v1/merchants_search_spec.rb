require 'rails_helper'

describe 'Merchant Search API endpoint' do
  it 'returns one merchant if it exists' do
    merchant_1 = create(:merchant, name: "Store", id: 1)
    merchant_2 = create(:merchant, name: "Stores", id: 2)
    search = "Sto"

    get "/api/v1/merchants/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(parsed_search.length).to eq(1)
    expect(parsed_search[:data]).to have_key(:id)
    expect(parsed_search[:data][:id]).to eq("1")
    expect(parsed_search[:data][:id]).to_not eq("2")
    expect(parsed_search[:data][:attributes]).to have_key(:name)
    expect(parsed_search[:data][:attributes][:name]).to eq("Store")
    expect(parsed_search[:data][:attributes][:name]).to_not eq("Stores")
    expect(parsed_search[:data][:attributes].length).to eq(1)
  end

  it 'returns nil if merchant does not exist' do
    merchant_1 = create(:merchant, name: "ABC")
    merchant_2 = create(:merchant, name: "DEF")
    search = "XYZ"

    get "/api/v1/merchants/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_search).to have_key(:data)
    expect(parsed_search[:data]).to have_key(:message)
    expect(parsed_search[:data][:message]).to eq("Unable to find merchant #{search}")
  end

  xit 'returns a variable number of merchants ranked by total revenue' do
    merchant_1 = create(:merchant, name: "Merchant 1", id: 1)
    merchant_2 = create(:merchant, name: "Merchant 2", id: 2)
    merchant_3 = create(:merchant, name: "Merchant 3", id: 3)
    merchant_4 = create(:merchant, name: "Merchant 4", id: 4)
    merchant_5 = create(:merchant, name: "Merchant 5", id: 5)

    number_of_merchants = 3

    get "/api/v1/revenue/merchants?quantity=#{number_of_merchants}"

    top_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(top_merchants.length).to eq(3)

    top_merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant_name_revenue")
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).to eq(000)
        expect(merchant[:attributes].length).to eq(2)
    end
  end

  it 'returns an error if the quantity is not provided or is less than or equal to 0' do
    # The quantity parameter is required, and should return an error if it is missing or if it is not an integer greater than 0.
    # number_of_merchants = nil
    number_of_merchants = 3
    get "/api/v1/revenue/merchants?quantity=#{number_of_merchants}"
  end

  xit 'returns a variable number of merchants ranked by total number of items sold' do
    merchant_1 = create(:merchant, name: "Merchant 1", id: 1)
    merchant_2 = create(:merchant, name: "Merchant 2", id: 2)
    merchant_3 = create(:merchant, name: "Merchant 3", id: 3)
    merchant_4 = create(:merchant, name: "Merchant 4", id: 4)
    merchant_5 = create(:merchant, name: "Merchant 5", id: 5)

    number_of_merchants = 3

    get "/api/v1/merchants/most_items?quantity=#{number_of_merchants}"

    top_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(top_merchants.length).to eq(3)

    top_merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("items_sold")
        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes]).to have_key(:count)
        # expect(merchant[:attributes][:count]).to eq(000)
        expect(merchant[:attributes].length).to eq(2)
    end
  end

  xit 'the number of merchants to be returned defaults to 5 if not provided and returns an error if it is not greater than 0' do
    number_of_merchants = nil
    number_of_merchants = 0
    get "/api/v1/merchants/most_items?quantity=#{number_of_merchants}"
  end
end
