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
end
