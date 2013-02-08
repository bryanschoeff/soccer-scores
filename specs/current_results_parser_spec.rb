require 'rspec'
require 'nokogiri'
require_relative '../lib/current_results_parser'

describe CurrentResultsParser do

  describe '.get_current_scores' do

    it "returns an empty array for no results" do
      page = Nokogiri::HTML("")
      Fetcher.stub(:fetch_current_scores) { page }
      results = CurrentResultsParser::get_current_scores
      results.should eq([])
    end

    it "returns an array of length 1 for a single league" do
      page = Nokogiri::HTML('<div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div>')
      Fetcher.stub(:fetch_current_scores) { page }
      results = CurrentResultsParser::get_current_scores
      results.count.should eq(1)
    end

    it "returns an array of length 3 for 3 minimal leagues" do
      page = Nokogiri::HTML('<div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div><div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div><div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div>')
      Fetcher.stub(:fetch_current_scores) { page }
      results = CurrentResultsParser::get_current_scores
      results.count.should eq(3)
    end

  end

  # Because everything in nested, we are going to test the 
  #   private methods separately and then do a rudimentary
  #   full stack test at the end
  #

  describe '.get_matches' do

    it 'should return an empty array for no matches' do
      matches = Nokogiri::HTML('')
      results = CurrentResultsParser::get_matches(matches)
      results.should eq([])
    end

    it 'should return an array of length 1 for a single match' do
      matches = Nokogiri::HTML('<tr id="test"><td class="scores"><a href="testURL"></a></td></tr>')
      results = CurrentResultsParser::get_matches(matches)
      results.length.should eq(1)
    end

    it 'should return an array of length 3 for 3 minimal matches' do
      matches = Nokogiri::HTML('<tr id="test"><td class="scores"><a href="testURL"></a></td></tr><tr id="test"><td class="scores"><a href="testURL"></a></td></tr><tr id="test"><td class="scores"><a href="testURL"></a></td></tr>')
      results = CurrentResultsParser::get_matches(matches)
      results.length.should eq(3)
    end

  end

  describe '.get_match' do

    it 'should return an appropriate single match for a minimal match' do
      match = Nokogiri::HTML('<td class="home_team">Home</td><td class="away_team">Away</td><td class="scores"><a href="">0-0</a></td><td class="scores"><a href="testURL"></a></td>')
      results = CurrentResultsParser::get_match(match)
      results.should eq({home_team: 'Home', away_team: 'Away', home_score: 0, away_score: 0, status: "" })
    end

  end

end
