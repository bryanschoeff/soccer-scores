require 'nokogiri'
require 'open-uri'

class Fetcher

  def self.fetch_current_scores
    Nokogiri::HTML(open("http://soccernet.espn.go.com/scores?cc=5901"), nil, 'UTF-8')
  end

  def self.fetch_scores_for_date(date)
    Nokogiri::HTML(open("http://soccernet.espn.go.com/scores?date=#{date}&league=all&cc=5901"), nil, 'UTF-8')
  end

  def self.fetch_match_statistics(match_id)
    Nokogiri::HTML(open("http://espnfc.com/us/en/gamecast/statistics/id/#{match_id}/statistics.html?soccernet=true&cc=5901"), nil, 'UTF-8')
  end

end
