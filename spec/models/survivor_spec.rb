require "rails_helper"


#Test suite for the survivor model
RSpec.describe Survivor,  type: :model do
  #Association Test to ensure that survivor has many trough relationship
  it { should have_many(:items).through(:inventory)}

  #Tests to validates the presence of the columns
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:age)}
  it { should validate_presence_of(:gender)}
  it { should validate_presence_of(:last_x)}
  it { should validate_presence_of(:last_y)}

  #Tests to validate the Numericality of the attributes
  it { should validate_numericality_of(:age).only_integer}
  it { should validate_numericality_of(:last_x)}
  it { should validate_numericality_of(:last_y)}
end
