class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.string :category

      t.timestamps
    end
  end
end
