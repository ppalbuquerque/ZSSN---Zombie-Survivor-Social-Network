class Survivor < ApplicationRecord
  #This is for the many-to-many relationship between the items and survivors
  has_many :inventory
  has_many :items, through: :inventory

  accepts_nested_attributes_for :inventory

  #Presence Validations
  validates_presence_of :name, :age, :gender, :last_x, :last_y

  #Numericality Validations
  validates_numericality_of :age, only_integer: true
  validates_numericality_of :last_x, :last_y

end
