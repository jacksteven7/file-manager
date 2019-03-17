class ResourcesController < ApplicationController
  def create
    file = Resource.new(name: params[:name])
    file.add_tags(params[:tags])
    
    if file.save
      render json: { uuid: file.uuid }, status: :created
    else
      render json: { errors: file.errors }, status: :unprocessable_entity
    end
  end

  def index
    files = Resource.all.includes(:tags)
    render json: { results: files }, status: :created
  end

  def search
    result = Resource.search(params[:tag_search_query], params[:page])
    render json: 
    { 
      total_records: result[:files].count,
      related_tags: result[:related_tags].map {|tag| { name: tag.name, file_count: tag.resources.count } },
      records: result[:files].map {|d| {name: d.name, uuid: d.uuid}} 
    }
  end
end
