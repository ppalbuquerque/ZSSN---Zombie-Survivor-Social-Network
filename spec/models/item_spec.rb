require 'rails_helper'

RSpec.describe Item, type: :model do
  #Association Test to ensure that survivor has many trough relationship
  it { should have_many(:survivors).through(:inventory)}

  #Validation tests, to ensure that the columns above exist before saving
  it { should validate_presence_of(:points)}
  it { should validate_presence_of(:name)}

  #Validation tests to ensure the Numericality of the attributes below
  it { should validate_numericality_of(:points)}
end
