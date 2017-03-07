class Item < ApplicationRecord
  #This is for the many-to-many relationship between the items and survivors
  has_many :inventory
  has_many :survivors, through: :inventory

  #Validations of the presence before saving
  validates_presence_of :name, :points

  #Validations of the Numericality
  validates_numericality_of :points
end
