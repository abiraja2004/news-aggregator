class AddRawToFeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :raw, :text
  end
end
