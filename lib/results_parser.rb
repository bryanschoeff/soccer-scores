require_relative 'fetcher'

class ResultsParser

  def self.get_current_scores
    page = Fetcher::fetch_current_scores
    get_leagues(page)
  end

  def self.get_scores_for_date(date)
    page = Fetcher::fetch_scores_for_date(date)
    get_leagues(page)
  end

  private

  def self.get_leagues(page)
    results = Array.new
    page.css('div.group-set').each do |league_html|
      results << get_league(league_html)
    end
    results
  end

  def self.get_league(league_html)
    league = {}

    league[:name] = league_html.css('h2 a').text
    league[:url] = league_html.css('h2 a').attr('href').content
    league[:matches] = get_matches(league_html)

    league
  end

  def self.get_matches(league_html)
    matches = []
    league_html.css('tr').each do |match_html|
      if match_html.attr('id')
        matches << get_match(match_html)
      end
    end
    matches
  end

  def self.get_match(match_html)
    match = {}
    nbsp = Nokogiri::HTML('&nbsp;')

    match[:status] = match_html.css('td.status').text
    match[:home_team] = match_html.css('td.home_team').text
    match[:away_team] = match_html.css('td.away_team').text
    match[:home_score] = match_html.css('td.scores a').text.split('-')[0].to_s.gsub(nbsp, '').to_i
    match[:away_score] = match_html.css('td.scores a').text.split('-')[1].to_s.gsub(nbsp, '').to_i
    match[:url] = match_html.css('td.scores a').attr('href').content if match_html.css('td.scores a').attr('href')
    match[:id] = /(\d*?)\/\w*?\.html/.match(match[:url]).captures[0] if match[:url] != ""

    match
  end

end
