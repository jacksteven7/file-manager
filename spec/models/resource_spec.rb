require 'rails_helper'

RSpec.describe Resource, type: :model do
   context "validation test" do
    it "create resource without name" do
      resource = Resource.new(name: "").save
      expect(resource).to eq false
    end
    
    it "create resource successful" do
      resource = Resource.new(name: "File1").save
      expect(resource).to eq true
    end

  end
end
