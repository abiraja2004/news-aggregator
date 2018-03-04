class Article < ApplicationRecord
  belongs_to :feed

  def raw
    fetch() if self[:raw].blank?
    return self[:raw]
  end

  def sentences
    simplified_html.split(/[\n\r\t]+/)
     .map{|x| ActionController::Base.helpers.strip_tags(x).strip}
     .reject{|x| x.blank?}
     .map{|x| Scalpel.cut(x)}
     .flatten.reject{|x| x.blank? || x.length < 3}
  end

  def summary
    sentences.first(3).join(' ')
  end

  ##############################################################################
  private
  ##############################################################################

  def fetch
    response = HTTParty.get(self.url)
    update_attributes!(:raw => response.body) if response.success?
    return response
  end

  def never_seen?
    Article.find_by(:feed_id => self.feed_id, :native_id => self.native_id).nil?
  end

  def rss_entry=(data)
    self.title        = data.title
    self.url          = data.url
    self.native_id    = data.entry_id
    self.published_at = data.published
  end

  def simplified_html
    Readability::Document.new(raw, :remove_empty_nodes => true).content.gsub(title,'')
  end

end
