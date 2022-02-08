require 'rails_helper'
# require 'json'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:id)
      expect(merchant[:attributes][:id]).to be_an(Integer)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end


  it "can get one merchant by its id" do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchant[:attributes]).to have_key(:id)
    expect(merchant[:attributes][:id]).to be_an(Integer)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    #wrote a test below for what I think Postman is looking for, don't
    #understand why it isn't working or what its looking for 
    task :task_name => [:dependent, :tasks] do

    end
    expect(merchant[:attributes].length).to eq(1)
    # pm.expect(Object.keys(data.attributes).length).to.eq(1);
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
end