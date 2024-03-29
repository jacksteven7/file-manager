class Tag < ApplicationRecord
  has_and_belongs_to_many :resources

  validates :name, presence: :true, format: { with: /\A(?!.*(?:\+|\s|-)).*\z/ , message: "can not contains whitespace, + or - signs." }

  def matching_files(files)
    (self.resources & files).count
  end
end
