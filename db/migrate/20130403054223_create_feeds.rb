class CreateFeeds < ActiveRecord::Migration
  def up
  	create_table :feeds do |t|
  		t.string :title
  		t.text :description
  		t.string :url
  		t.timestamps
  	end
  end

  def down
  	drop_table :feeds
  end
end
