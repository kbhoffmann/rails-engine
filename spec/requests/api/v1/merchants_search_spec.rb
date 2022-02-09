require 'rails_helper'

describe 'Merchant Search API endpoint' do
  it 'returns one merchant if it exists' do
    merchant_1 = create(:merchant, name: "Store", id: 1)
    merchant_2 = create(:merchant, name: "Stores", id: 2)
    search = "Store"

    get "/api/v1/merchants/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true) [:data]

    expect(response).to be_successful

    expect(parsed_search).to have_key(:id)
    expect(parsed_search[:id]).to eq("1")
    expect(parsed_search[:id]).to_not eq("2")
    expect(parsed_search[:attributes]).to have_key(:name)
    expect(parsed_search[:attributes][:name]).to eq("Store")
    expect(parsed_search[:attributes][:name]).to_not eq("Stores")
    expect(parsed_search[:attributes].length).to eq(1)
  end

  it 'can return another merchant' do
    merchant_1 = create(:merchant, name: "Burt's Shop", id: 5)
    merchant_2 = create(:merchant, name: "Burt's Bazaar", id: 7)
    search = "Burt's Bazaar"

    get "/api/v1/merchants/find?name=#{search}"

    parsed_search = JSON.parse(response.body, symbolize_names: true) [:data]

    expect(response).to be_successful

    expect(parsed_search).to have_key(:id)
    expect(parsed_search[:id]).to eq("7")
    expect(parsed_search[:id]).to_not eq("5")
    expect(parsed_search[:attributes]).to have_key(:name)
    expect(parsed_search[:attributes][:name]).to eq("Burt's Bazaar")
    expect(parsed_search[:attributes][:name]).to_not eq("Burt's Shop")
    expect(parsed_search[:attributes].length).to eq(1)
  end
end
