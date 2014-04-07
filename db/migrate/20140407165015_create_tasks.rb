class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.boolean :done
      t.string :title
      t.text :detail

      t.timestamps
    end
  end
end
