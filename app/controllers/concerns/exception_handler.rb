# It is a helper which gonna provide some rescue from the RecordNotFound
# and the RecordInvalid exceptions and it will returns a 404 or a 422 code
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message}, :unprocessable_entity)
    end

  end
end
