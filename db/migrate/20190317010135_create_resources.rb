class CreateResources < ActiveRecord::Migration[5.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
