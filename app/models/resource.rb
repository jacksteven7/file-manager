class Resource < ApplicationRecord
  has_and_belongs_to_many :tags
  
  validates :name, :presence => :true
  before_save :assign_uuid   
  
  QRY_TAG_EPX = /[\A(\+\-)](\w*)/
  ADD_TAG_EPX = /\+(\w*)/
  SUB_TAG_EPX = /\-(\w*)/


  def add_tags(tags)
    tags.each do | tag |
      t = Tag.find_or_create_by(name: tag)
      self.tags << t
    end
  end

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end

  def self.search(query, page)
    tags , tags_in, tags_out = extract_tags(query)
    resources = extract_resources(tags_in, tags_out)
    
    { files: resources, related_tags: tags }
  end

  private

  def self.extract_tags(query)
    [ Tag.all - get_tags(query,QRY_TAG_EPX), get_tags(query,ADD_TAG_EPX), get_tags(query,SUB_TAG_EPX) ]
  end

  def self.get_tags(query, exp)
    Tag.where("name IN (?)", query.scan(exp).flatten)
  end

  def self.extract_resources(tags_in, tags_out)
    get_resources(tags_in) - get_resources(tags_out)
  end

  def self.get_resources(tags)
    Resource.joins(:tags).select(:name,:uuid).group(:name,:uuid).having("array_agg(tag_id::integer) @> array#{tags.map(&:id)}")
  end

end
