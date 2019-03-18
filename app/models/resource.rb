require 'will_paginate/array'
class Resource < ApplicationRecord
  has_and_belongs_to_many :tags
  
  validates :name, :presence => :true
  before_create :assign_uuid   
  
  #Regex used to extract tags from tag_search_query param
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

  def self.search(query)
    related_tags , tags_in, tags_out = extract_tags(query)
    resources = extract_resources(tags_in, tags_out).sort

    { files: resources, related_tags: related_tags }
  end

  def self.paginate(files, page)
    files.paginate(:page => page, :per_page => 10)
  end

  private

  def self.extract_tags(query)
    [ Tag.all - get_tags(query,QRY_TAG_EPX), get_tags(query,ADD_TAG_EPX), get_tags(query,SUB_TAG_EPX) ]
  end

  def self.get_tags(query, exp)
    Tag.where("name IN (?)", query.scan(exp).flatten)
  end

  def self.extract_resources(tags_in, tags_out)
    get_resources(tags_in) - get_excluded_resources(tags_out)
  end

  def self.get_resources(tags)
    return Resource.joins(:tags).none if tags.empty?
    Resource.joins(:tags).select(:id,:name,:uuid).group(:id,:name,:uuid).having("array_agg(tag_id::integer) @> array#{tags.map(&:id)}")
  end

  def self.get_excluded_resources(tags_out)
    excluded_resources = [] 
    tags_out.each do | tag |
      excluded_resources << get_resources([tag])
    end
    excluded_resources.flatten
  end

end
