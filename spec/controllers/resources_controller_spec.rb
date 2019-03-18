require 'rails_helper'
require 'pry'

describe ResourcesController, type: :controller do
  it "create a new file sucessfully" do
    file_params = {name: "File1", tags:["Tag1"]}    
    expect { create_file(file_params) }.to change(Resource, :count).by(1)
  end

  it "create a new file unsucessfully" do
    file_params = {name: "File1", tags:[]}    
    expect { create_file(file_params) }.to change(Resource, :count).by(0)
  end

  it "filter files by tags" do
    load_sample_data
    
    file_params = {tag_search_query: "+Tag1-Tag2", page: 2}    
    get :search, :params => file_params
    data = JSON.parse(response.body)
    
    expect(data["total_records"]).to eq 15
    #second page should return only 5 items
    expect(data["records"].count).to eq 5
  end

  def create_file(file_params)
    post :create, :params => file_params
  end

  def load_sample_data
    15.times { |i| create_file({name: "File#{i}", tags:["Tag1"]}) }
    15.times { |i| create_file({name: "File#{i}", tags:["Tag2"]}) }
  end
    

end
