require 'nokogiri'
require 'open-uri'


class Fetcher

  def self.fetch_current_scores
    Nokogiri::HTML(open("http://soccernet.espn.go.com/scores?cc=5901"), nil, 'UTF-8')
  end

end
