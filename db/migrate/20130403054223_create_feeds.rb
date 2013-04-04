class CreateFeeds < ActiveRecord::Migration
  def up
  	create_table :feeds do |t|
  		t.string :title
  		t.text :description
  		t.string :url
  		t.timestamps
  	end

    Feed.create({
      :title => "iPc.me",
      :description => "iPc.me - 与你分享互联网的精彩！",
      :url=> "http://feed.ipc.me/"
    })
    Feed.create({
      :title => "電腦玩物",
      :description => "電腦玩物",
      :url => "http://playpcesor.blogspot.com/feeds/posts/default"
    })
  end

  def down
  	drop_table :feeds
  end
end
