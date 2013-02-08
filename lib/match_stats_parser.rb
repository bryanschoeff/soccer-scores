require_relative 'fetcher'

class MatchStatsParser
  attr_accessor :location, :status, :home_team, :away_team, :home_stats, :away_stats

  def self.get_match_statistics(match_id)
    results = {home_stats: {}, away_stats: {}}
    match_stats = Fetcher::get_match_statistics(match_id)

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
        player_stats = {}
        table_cells = table_row.css('td')

        player_stats[:line_up] = line_up
        player_stats[:position] = table_cells[0].css('p').text if table_cells[0]
        player_stats[:number] = table_cells[1].text if table_cells[1]
        player_stats[:name] = table_cells[2].css('a').text.strip if table_cells[2]
        player_stats[:shots] = table_cells[3].text.strip if table_cells[3]
        player_stats[:shots_on_goal] = table_cells[4].text.strip if table_cells[4]
        player_stats[:goals] = table_cells[5].text.strip if table_cells[5]
        player_stats[:assists] = table_cells[6].text.strip if table_cells[6]
        player_stats[:offsides] = table_cells[7].text.strip if table_cells[7]
        player_stats[:fouls_drawn] = table_cells[8].text.strip if table_cells[8]
        player_stats[:fouls_committed] = table_cells[9].text.strip if table_cells[9]
        player_stats[:saves] = table_cells[10].text.strip if table_cells[10]
        player_stats[:yellow_cards] = table_cells[11].text.strip if table_cells[11]
        player_stats[:red_cards] = table_cells[12].text.strip if table_cells[12]

        players_stats << player_stats
      end
    end
    players_stats
  end

end
