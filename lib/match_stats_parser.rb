require_relative 'fetcher'

class MatchStatsParser

  def self.get_match_statistics(match_id)
    results = {home_stats: {}, away_stats: {}}
    match_stats = Fetcher::get_match_statistics(match_id)

    results[:home_team] = match_stats.css('div.team.away p.team-name a').text
    results[:away_team] = match_stats.css('div.team.home p.team-name a').text
    results[:home_score] = match_stats.css('div.score-time p.score').text.split('-')[0].strip
    results[:away_score] = match_stats.css('div.score-time p.score').text.split('-')[1].strip
    results[:status] = match_stats.css('div.score-time p.time').text

    # this could be refactored to be more DRY; it doesn't seem necessary right now
    results[:home_stats][:shots] = match_stats.css('#home-shots').text
    results[:home_stats][:fouls] = match_stats.css('#home-fouls').text
    results[:home_stats][:corner_kicks] = match_stats.css('#home-corner-kicks').text
    results[:home_stats][:offsides] = match_stats.css('#home-offsides').text
    results[:home_stats][:time_of_possession] = match_stats.css('#home-possession').text
    results[:home_stats][:yellow_cards] = match_stats.css('#home-yellow-cards').text
    results[:home_stats][:red_cards] = match_stats.css('#home-red-cards').text
    results[:home_stats][:saves] = match_stats.css('#home-saves').text

    results[:home_stats][:player_stats] = get_players_stats(match_stats.css('h1#home-team + table'))

    results[:away_stats][:shots] = match_stats.css('#away-shots').text
    results[:away_stats][:fouls] = match_stats.css('#away-fouls').text
    results[:away_stats][:corner_kicks] = match_stats.css('#away-corner-kicks').text
    results[:away_stats][:offsides] = match_stats.css('#away-offsides').text
    results[:away_stats][:time_of_possession] = match_stats.css('#away-possession').text
    results[:away_stats][:yellow_cards] = match_stats.css('#away-yellow-cards').text
    results[:away_stats][:red_cards] = match_stats.css('#away-red-cards').text
    results[:away_stats][:saves] = match_stats.css('#away-saves').text

    results[:away_stats][:player_stats] = get_players_stats(match_stats.css('h1#away-team + table'))

    results

  end

  private

  def self.get_players_stats(players_html)
    players_stats = Array.new
    line_up = 'Line-Up'

    players_html.css('tbody tr').each do |table_row|

      if (table_row.css('th').count == 1)
        line_up = table_row.css('th').text.strip
      elsif (table_row.css('th').count == 0)
        players_stats << get_player_stats(table_row, line_up)
      end
    end
    players_stats
  end

  def self.get_player_stats(player_html, line_up)
    player_stats = {}
    stat_columns = player_html.css('td')

    player_stats[:line_up] = line_up
    player_stats[:position] = stat_columns[0].css('p').text if stat_columns[0]
    player_stats[:number] = stat_columns[1].text if stat_columns[1]
    player_stats[:name] = stat_columns[2].css('a').text.strip if stat_columns[2]
    player_stats[:shots] = stat_columns[3].text.strip if stat_columns[3]
    player_stats[:shots_on_goal] = stat_columns[4].text.strip if stat_columns[4]
    player_stats[:goals] = stat_columns[5].text.strip if stat_columns[5]
    player_stats[:assists] = stat_columns[6].text.strip if stat_columns[6]
    player_stats[:offsides] = stat_columns[7].text.strip if stat_columns[7]
    player_stats[:fouls_drawn] = stat_columns[8].text.strip if stat_columns[8]
    player_stats[:fouls_committed] = stat_columns[9].text.strip if stat_columns[9]
    player_stats[:saves] = stat_columns[10].text.strip if stat_columns[10]
    player_stats[:yellow_cards] = stat_columns[11].text.strip if stat_columns[11]
    player_stats[:red_cards] = stat_columns[12].text.strip if stat_columns[12]

    player_stats
  end

end
