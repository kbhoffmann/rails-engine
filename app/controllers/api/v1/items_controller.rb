class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      # render json: { errors: {title: "Not Found", details: "This Item does not exist", status: 404}}, status: 404
      render status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      # render json: { errors: {title: "Bad Request", details: "An Item cannot be created as requested", status: 400} }, status: 400
      render status: 400
    end
  end

  def update
    item = Item.find(params[:id])
     if item.update(item_params)
       render json: ItemSerializer.new(item)
     else
       render status: 400
     end
  end

  def destroy
    if Item.exists?(params[:id])
      Item.find(params[:id]).destroy
    else
      render status: 404
    end
    #destroy the invoice if this is the only item on the invoice
      #dependant, destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
