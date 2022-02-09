class Api::V1::MerchantsSearchController < ApplicationController
  def show
    # merchant = Merchant.find_by_name(params[:name])
    merchant = Merchant.find_merchant_by_name(params[:name])[0]
    render json: MerchantSerializer.new(merchant)
  end
end
