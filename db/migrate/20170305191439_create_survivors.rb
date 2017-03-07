class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.float :last_x
      t.float :last_y
      t.integer :report_infected, :default => 0

      t.timestamps
    end

    create_table :inventories, id: false do |t|
      t.belongs_to :survivor, index: true
      t.belongs_to :item, index: true
      t.integer :quant, :default => 0
    end
  end
end
