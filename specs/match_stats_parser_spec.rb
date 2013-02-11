require 'rspec'
require 'nokogiri'
require_relative '../lib/match_stats_parser'
require_relative '../lib/fetcher'

describe MatchStatsParser do

  describe '.get_match_statistics' do

    def prepare_match(page_string)
      page = Nokogiri::HTML(page_string)
      Fetcher.stub(:fetch_match_statistics).with(1) { page }
      MatchStatsParser::get_match_statistics 1
    end

    it 'should return an empty hash for no results' do
      results = prepare_match("")
      results.should eq({})
    end

    it 'should return baseline stats for a good id' do
      results = prepare_match('<div class="team home"><p class="team-name"><a>Home</a></p></div><div class="team away"><p class="team-name"><a>Away</a></p></div><div class="score-time"><p class="score">0-0</p><p class="time">FT</p></div>')
      results.should eq({home_team:"Away", away_team:"Home", home_score:0, away_score:0, status:"FT", home_stats:{shots:"", fouls:"", corner_kicks:"", offsides:"", time_of_possession:"", yellow_cards:"", red_cards:"", saves:"", player_stats:[]}, away_stats:{shots:"", fouls:"", corner_kicks:"", offsides:"", time_of_possession:"", yellow_cards:"", red_cards:"", saves:"", player_stats:[]}})
    end

  end

  describe '.get_team_stats' do

    def prepare_team(page_string, team)
      page = Nokogiri::HTML(page_string)
      MatchStatsParser::get_team_stats(page, team)
    end

    it 'should return a baseline hash for no stats' do
      results = prepare_team('', 'home')
      results.should eq({shots:"",fouls:"",corner_kicks:"",offsides:"",time_of_possession:"",yellow_cards:"",red_cards:"",saves:"",player_stats:[]})
    end

    it 'should return the appropriately set values for a minimal page' do
      results = prepare_team('<div id="home-shots">10(1)</div><div id="home-fouls">2</div><div id="home-corner-kicks">3</div><div id="home-offsides">4</div><div id="home-possession">5</div><div id="home-yellow-cards">6</div><div id="home-red-cards">7</div><div id="home-saves">8</div>', 'home')
      results.should eq({shots:"10",shots_on_goal: "1",fouls:"2",corner_kicks:"3",offsides:"4",time_of_possession:"5",yellow_cards:"6",red_cards:"7",saves:"8",player_stats:[]})
    end

  end

  describe '.get_players_stats' do

    def prepare_players(page_string)
      page = Nokogiri::HTML(page_string)
      MatchStatsParser::get_players_stats(page)
    end

    it 'should return an empty array for no players found' do
      results = prepare_players('')
      results.should eq([])
    end

    it 'should return an array of length 1 for a single player row' do
      results = prepare_players('<tbody><tr class=""></tr></tbody>')
      results.length.should eq(1)
    end

    it 'should return an array of length 5 for 5 player rows' do
      results = prepare_players('<tbody><tr class=""></tr><tr class=""></tr><tr class=""></tr><tr class=""></tr><tr class=""></tr></tbody>')
      results.length.should eq(5)
    end

  end

  describe '.get_player_stats' do

    def prepare_player(page_string, line_up)
      page = Nokogiri::HTML(page_string)
      MatchStatsParser::get_player_stats(page, line_up)
    end

    it 'should return just the line up in the hash for no stats' do
      results = prepare_player('', 'Lineup')
      results.should eq({line_up:"Lineup"})
    end

    it 'should return the appropriately set values for a minimal page' do
      results = prepare_player('<td><p>1</p></td><td>2</td><td><a>3</a></td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td>', 'Lineup')
      results.should eq({:line_up=>"Lineup", :position=>"1", :number=>"2", :name=>"3", :shots=>"4", :shots_on_goal=>"5", :goals=>"6", :assists=>"7", :offsides=>"8", :fouls_drawn=>"9", :fouls_committed=>"10", :saves=>"11", :yellow_cards=>"12", :red_cards=>"13"})
    end

    it 'should return remove the default dashes for no value' do
      results = prepare_player('<td><p>1</p></td><td>2</td><td><a>3</a></td><td>4</td><td>5</td><td>-</td><td>-</td><td>8</td><td>9</td><td>10</td><td>11</td><td>12</td><td>13</td>', 'Lineup')
      results.should eq({:line_up=>"Lineup", :position=>"1", :number=>"2", :name=>"3", :shots=>"4", :shots_on_goal=>"5", :goals=>"", :assists=>"", :offsides=>"8", :fouls_drawn=>"9", :fouls_committed=>"10", :saves=>"11", :yellow_cards=>"12", :red_cards=>"13"})
    end

  end

end

