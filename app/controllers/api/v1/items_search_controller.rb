class Api::V1::ItemsSearchController < ApplicationController
  def index
    #break into if statements for params or do in model to keep controller skinny
    #if params[:name]
    items = Item.find_all_items_by_name(params[:name])[0]

    if items.nil?
      render json: {data: {message: "No items match your search"}}
    else
      render json: ItemSerializer.new(items)
    end
  end
end
