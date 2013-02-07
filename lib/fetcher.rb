require 'nokogiri'
require 'open-uri'

class Fetcher

  def self.get_current_scores

    results = Array.new

    page = Nokogiri::HTML(open("http://soccernet.espn.go.com/scores?cc=5901"), nil, 'UTF-8')
    nbsp = Nokogiri::HTML('&nbsp;')

    # Factor out this block
    page.css('div.group-set').each do |league_html|

      league = {}

      league[:name] = league_html.css('h2 a').text
      league[:url] = league_html.css('h2 a').attr('href').content
      league[:matches] = []

      # Factor out this block
      league_html.css('tr').each do |match_html|
        if match_html.attr('id')

          match = {}

          match[:status] = match_html.css('td.status').text
          match[:home_team] = match_html.css('td.home_team').text
          match[:away_team] = match_html.css('td.away_team').text
          match[:home_score] = match_html.css('td.scores a').text.split('-')[0].to_s.gsub(nbsp, '').to_i
          match[:away_score] = match_html.css('td.scores a').text.split('-')[1].to_s.gsub(nbsp, '').to_i
          match[:url] = match_html.css('td.scores a').attr('href').content

          league[:matches] << match

        end
      end
      results << league
    end

    results
  end
end
