class Inventory < ActiveRecord::Base
  belongs_to :survivor
  belongs_to :item

  # Validating the presence
  validates_presence_of :quant
end
