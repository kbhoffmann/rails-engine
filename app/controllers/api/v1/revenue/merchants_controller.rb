class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    #need to add sad path
    merchants = Merchant.top_merchants_by_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end
end
