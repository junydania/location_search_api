require 'rails_helper'

RSpec.describe Place, type: :model do
  
  it { should have_attributes(latitude: 34, longitude:50) }
end
