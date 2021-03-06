class Api::V1::MerchantsSearchController < ApplicationController
  def show
    merchant = Merchant.find_merchant_by_name(params[:name])[0]
    if merchant.nil?
      render json: {data: {message: "Unable to find merchant #{params[:name]}" }}
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
