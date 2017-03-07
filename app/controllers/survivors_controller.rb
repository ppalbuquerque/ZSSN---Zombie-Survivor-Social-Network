class SurvivorsController < ApplicationController
  # Setting the survivor before running the method
  before_action :set_survivor, only: [:update_location, :show,
                :report_infection, :points_lost,:inventory_show]

  # GET /survivors
  def list
    # It retrieves all the survivors
    @survivors = Survivor.all
    # Taking out the infected ones
    healthly_survivors = Array.new
    @survivors.each do |s|
      healthly_survivors << s unless is_infected?(s)
    end
    json_response(healthly_survivors)
  end

  # GET /survivors/:id
  def show
    #It returns a survivor by its id if he is healtly
    return json_response(@survivor) unless is_infected?(@survivor)
    # Creating the json msg that the survivor is infected
    infected
  end

  # GET /survivors/:id/inventory
  def inventory_show
    # Aux hash to save the information
    inventory_h = Hash.new
    # Check if the survivor is infected before anything
    return infected unless !is_infected?(@survivor)
    # Building the hash
    @survivor.inventory.each do |ivn|
      # Searchin the item
      item_t = Item.find(ivn.item_id)
      inventory_h[item_t.name] = ivn.quant
    end
    json_response(inventory_h, :ok)
  end

  # POST /survivors
  def create
    # It creates a new survivor with the params from the http request
    @survivor = Survivor.create!(survivors_params)
    # Testing if the items_params['items'] is nil, if it is it will return straight way, but is fine
    return json_response(@survivor, :created) if items_params['items'] == nil
    # Now i search the items and add to the survivors inventory
    items_params['items'].each do |i|
      # First i find the item
      item = Item.find(i['id'])
      # Then i insert in the 'invetory' of the survivor
      @survivor.inventory.create(:item => item, :quant => i['quant'])
    end
    json_response(@survivor, :created)
  end

  # PUT /survivors/update_location
  def update_location
    # Updating the survivor location unless he is infected
    return @survivor.update(survivors_params) unless is_infected?(@survivor)
    infected
  end

  # PUT /survivors/report_infection
  def report_infection
    # Creating a temp hash to pass as argument of update
    t_hash = Hash.new
    t_hash['report_infected'] = @survivor.report_infected + 1
    @survivor.update(t_hash)
    json_response(@survivor, :accepted)
  end

  # PUT /survivors/trade
  def trade
    # Hashs to save the information about the items related in the trade
    inventory_s1 = Hash.new
    inventory_s2 = Hash.new

    # Retrieving the survivors
    @survivor_1 = Survivor.find(trade_params['items_1'][0]['s_id'])
    @survivor_2 = Survivor.find(trade_params['items_2'][0]['s_id'])

    # Check if any of the two survivors are infected and stop the method
    return infected unless !is_infected?(@survivor_1) && !is_infected?(@survivor_2)

    # Aux Variables to check the sum of points
    total_points_1 = 0
    total_points_2 = 0

    # Searching through the array of items for the first survivor
    trade_params['items_1'].each do |elm|
      # auxiliar hash to save the inventory objects
      inventory_s1[elm['it_id']] = elm['quant']
      total_points_1 += Item.find(elm['it_id']).points * Integer(elm['quant'])
    end

    # Searching through the array of items for the second survivor
    trade_params['items_2'].each do |elm|
      # auxiliar hash to save the inventory objects
      inventory_s2[elm['it_id']] = elm['quant']
      total_points_2 += Item.find(elm['it_id']).points * Integer(elm['quant'])
    end

    # Check if the trade is equivalent
    return json_response({:message => "The trade is not equivalent"}, :forbidden) if total_points_1 != total_points_2

    # Making the trade
    inventory_s2.each do |k,v|
      # Boolean flag to see if the survivor 1 already has the item
      is_missing = true
      @survivor_1.inventory.each do |ivn|
        if k == ivn.item_id
          t_hash = Hash.new
          t_hash['quant'] = ivn.quant + v
          # Updates the quantity of the trade item
          @survivor_1.inventory.where('item_id = ?', k).update_all(quant: ivn.quant + v)
          is_missing = false
          break
        end
      end
      # Creates the row in the join table inventory if the survivor dont have the item
      @survivor_1.inventory.create(:item => Item.find(k), :quant => v) if is_missing
    end

    inventory_s1.each do |k,v|
      is_missing = true
      @survivor_2.inventory.each do |ivn|
        if k == ivn.item_id
          t_hash = Hash.new
          @survivor_2.inventory.where('item_id = ?', k).update_all(quant: ivn.quant + v)
          ivn.update(t_hash)
          is_missing = false
          break
        end
      end
      @survivor_2.inventory.create(:item => Item.find(k), :quant => v) if is_missing
    end

    inventory_s2.each do |k,v|
      t_hash = Hash.new
      t_ivn = nil
      @survivor_2.inventory.each do |ivn|
        if k == ivn.item_id
          t_hash['quant'] = ivn.quant - v
          @survivor_2.inventory.where('item_id = ?', k).update_all(quant: ivn.quant - v)
          is_missing = false
          break
        end
      end
      # Erase the row in the inventory table if the quant of the item is 0
      @survivor_2.items.delete(Item.find(k)) if t_hash['quant'] == 0
    end

    inventory_s1.each do |k,v|
      t_hash = Hash.new
      t_ivn = nil
      @survivor_1.inventory.each do |ivn|
        if k == ivn.item_id
          t_hash['quant'] = ivn.quant - v
          @survivor_1.inventory.where('item_id = ?', k).update_all(quant: ivn.quant - v)
          is_missing = false
          break
        end
      end
      @survivor_1.items.delete(Item.find(k)) if t_hash['quant'] == 0
    end
  end

  private

  # Getting the params from the http request
  def survivors_params
    params.permit(:name, :age, :gender, :last_x, :last_y)
  end

  # Getting the array of hash that is need for the inventory
  def items_params
    params.permit(:items => [:id, :quant])
  end

  # Getting the params for the trade
  def trade_params
    params.permit(:items_1 => [:s_id, :it_id, :quant], :items_2 => [:s_id, :it_id, :quant])
  end

  # Setting the survivor via the id
  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  # Method that asks if the survivor is infected
  def is_infected?(survivor)
    survivor.report_infected >= 3 ? true : false
  end

  # Method to creates a json when the survivor is infected
  def infected
    msg = {:message => "The survivor is infected"}
    json_response(msg, :forbidden)
  end

end
