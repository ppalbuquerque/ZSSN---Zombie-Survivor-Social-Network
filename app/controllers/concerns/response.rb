# It's just a helper to render the json, basicaly it takes the objects generate it json representation
# And has a default 200 status
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
