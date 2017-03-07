class ReportController < ApplicationController
  before_action :set_survivor, only: [:points_lost]

  # GET /infected_rel
  def infected
    # Getting all the survivors
    @survivors_list = Survivor.all
    # Aux variable to save the total of infected survivors
    total_infected = 0
    # Searching through the survivors for the ones that are infected
    @survivors_list.each do |s|
      total_infected += 1 if is_infected?(s)
    end
    # Calculating the percent of infected
    infected_percent = (total_infected.to_f / @survivors_list.length.to_f) * 100
    # Creates a objects that saves the information
    report = {:total => @survivors_list.length, :infected => total_infected,
        :percent_infected => infected_percent, :percent_non_infected => 100 - infected_percent}
    # Generate the json response
    json_response(report)
  end

  # GET /infected/:id
  def points_lost
    # Aux variable that holds the total of lost points
    total_lost_points = 0
    # Check if the survivor is not infected
    return unless is_infected?(@survivor)
    # searching through the iventory of the infected survivor
    @survivor.inventory.each do |ivn|
      # getting the item data
      t_item = Item.find(ivn.item_id)
      # Adding to the lost points
      total_lost_points += t_item.points * ivn.quant
    end
    # Creating the object for the json_response
    msg = {:survivor_id => @survivor.id, :survivor_name => @survivor.name,
        :total_lost_points => total_lost_points}
    json_response(msg)
  end


  # GET /resources_rel
  def resources
    # Getting all the entries in the join table invetories
    inventories = Inventory.all
    # Creating a new hash that holdes the amount of each item
    items = Hash.new(0)
    # Searching through the inventory
    inventories.each do |ivn|
      # Getting the item
      item_t = Item.find(ivn.item_id)
      items[item_t.name] += ivn.quant
    end
    # Getting all the survivors
    @survivors = Survivor.all
    # Cleaning the infected ones
    healthly_survivors = Array.new
    @survivors.each do |s|
      healthly_survivors << s unless is_infected?(s)
    end
    # Callculating the percentage
    items.each do |k,v|
      items[k] = v.to_f / healthly_survivors.length.to_f
    end
    json_response(items)
  end

  private

  # Setting the survivor via the id
  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  # Method that asks if the survivor is infected
  def is_infected?(survivor)
    survivor.report_infected >= 3 ? true : false
  end
end
