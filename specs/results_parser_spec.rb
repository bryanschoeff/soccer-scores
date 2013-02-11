require 'rspec'
require 'nokogiri'
require_relative '../lib/results_parser'

describe ResultsParser do

  describe '.get_current_scores' do

    def prepare_page(page_string)
      page = Nokogiri::HTML(page_string)
      Fetcher.stub(:fetch_current_scores) { page }
      ResultsParser::get_current_scores
    end

    it "returns an empty array for no results" do
      results = prepare_page('')
      results.should eq([])
    end

    it "returns an array of length 1 for a single league" do
      results = prepare_page('<div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div>')
      results.count.should eq(1)
    end

    it "returns an array of length 3 for 3 minimal leagues" do
      results = prepare_page('<div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div><div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div><div class="group-set"><h2><a href="testURL">Test League Name</a></h2></div>')
      results.count.should eq(3)
    end

  end

  # Because everything in nested, we are going to test the
  #   private methods separately.

  describe '.get_matches' do

    def prepare_matches(matches_string)
      matches = Nokogiri::HTML(matches_string)
      ResultsParser::get_matches(matches)
    end

    it 'should return an empty array for no matches' do
      results = prepare_matches('')
      results.should eq([])
    end

    it 'should return an array of length 1 for a single match' do
      results = prepare_matches('<tr id="test"><td class="scores"><a href="12345/test.html"></a></td></tr>')
      results.length.should eq(1)
    end

    it 'should return an array of length 3 for 3 minimal matches' do
      results = prepare_matches('<tr id="test"><td class="scores"><a href="12345/test.html"></a></td></tr><tr id="test"><td class="scores"><a href="12345/test.html"></a></td></tr><tr id="test"><td class="scores"><a href="12345/test.html"></a></td></tr>')
      results.length.should eq(3)
    end

  end

  describe '.get_match' do

    it 'should return an appropriate single match for a minimal match' do
      match = Nokogiri::HTML('<td class="home_team">Home</td><td class="away_team">Away</td><td class="scores"><a href="12345/test.html">0-0</a></td><td class="scores"><a href="testURL"></a></td>')
      results = ResultsParser::get_match(match)
      results.should eq({home_team: 'Home', away_team: 'Away', home_score: 0, away_score: 0, status: "", url: "12345/test.html", id: "12345" })
    end

  end

end
