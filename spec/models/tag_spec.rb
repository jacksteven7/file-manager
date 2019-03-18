require 'rails_helper'

RSpec.describe Tag, type: :model do
  context "validation test" do
    it "create resource without name" do
      tag = Tag.new(name: "").save
      expect(tag).to eq false
    end
    
    it "create resource without name1" do
      resource = Resource.new(name: "Tag1").save
      expect(resource).to eq true
    end

  end
end
