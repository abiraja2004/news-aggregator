class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.references :feed, foreign_key: true
      t.string :native_id
      t.string :title
      t.text :raw
      t.string :url
      t.datetime :published_at
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
