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

  def search
    result = Resource.search(params[:tag_search_query])

    render json: 
    { 
      total_records: result[:files].count,
      related_tags: result[:related_tags].map { |tag| { name: tag.name, file_count: tag.matching_files(result[:files]) }},
      records: Resource.paginate(result[:files], params[:page]).map { |d| {name: d.name, uuid: d.uuid} } 
    }
  end
end
