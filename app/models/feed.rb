require 'httparty'

class Feed < ApplicationRecord

  has_many :articles

  def raw
    fetch() if self[:raw].blank?
    return self[:raw]
  end

  def fetch
    response = HTTParty.get(self.url)
    update_attributes!(:raw => response.body) if response.success?
    return response
  end

  def entries
    Feedjira::Feed.parse(raw).entries rescue nil
  end

  def refresh
    articles = entries.map do |entry|
      Article.new(
        :feed_id      => self.id,
        :rss_entry    => entry
      )
    end

    articles.select{|a| a.never_seen?}.each{|a| a.save!}
  end

end
