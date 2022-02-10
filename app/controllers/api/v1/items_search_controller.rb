class Api::V1::ItemsSearchController < ApplicationController
  def index
    if params[:name]
      items = Item.find_all_items_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      items = Item.find_all_items_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    elsif params[:max_price]
      items = Item.find_all_items_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    # if items.nil?
    #   render json: {data: {message: "No items match your search"}}
    # else
    #   render json: ItemSerializer.new(items)
     end
  end
end
