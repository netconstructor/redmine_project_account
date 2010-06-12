class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.string      :description
      t.decimal     :amount, :precision => 10, :scale => 2
      t.date        :date
      t.index       :date
      t.belongs_to  :project
      t.index       :project_id
    end
  end

  def self.down
    drop_table :line_items
  end
end
