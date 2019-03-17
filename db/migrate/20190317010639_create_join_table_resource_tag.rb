class CreateJoinTableResourceTag < ActiveRecord::Migration[5.1]
  def change
    create_join_table :resources, :tags do |t|
      # t.index [:resource_id, :tag_id]
      # t.index [:tag_id, :resource_id]
    end
  end
end
