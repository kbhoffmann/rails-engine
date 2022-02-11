class Api::V1::ItemsSearchController < ApplicationController
  def index
    # items = if…end
    if params[:name]
      items = Item.find_all_items_by_name(params[:name])
    elsif params[:min_price] && params[:max_price]
      items = Item.find_all_items_by_price_range(params[:min_price], params[:max_price])
    elsif params[:min_price]
      items = Item.find_all_items_by_min_price(params[:min_price])
    elsif params[:max_price]
      items = Item.find_all_items_by_max_price(params[:max_price])
    end
      render json: ItemSerializer.new(items)
  end
end
