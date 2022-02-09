class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {errors: "Not Found" }, status: 404
    end
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: 201
    #add sad path with error if unable to save item, 400 status???
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
    Item.find(params[:id]).destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
