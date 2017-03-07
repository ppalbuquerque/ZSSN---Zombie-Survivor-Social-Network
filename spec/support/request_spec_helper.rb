module RequestSpecHelper
  # Parse JSON response into a ruby hash
  def json
    JSON.parse(response.body)
  end
end
