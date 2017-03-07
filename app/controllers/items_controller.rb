class ItemsController < ApplicationController

  # GET /items
  def list
    # It retrieves all the items
    @items = Item.all
    json_response(@items)
  end

  # POST /items
  def create
    # It creates a new item with the param un the request and build a json_response with
    @item = Item.create!(items_params)
    json_response(@item, :created)
  end

  private

  # Getting the param from http request
  def items_params
    params.permit(:name, :points)
  end
end
