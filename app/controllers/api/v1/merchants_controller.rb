class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def most_items
    merchants = Merchant.top_merchants_by_items_sold(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end

  def show
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: {data: {message: "Merchant not found" }}, status: 404
    end
  end
end
