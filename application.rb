require 'sinatra'
require 'json'
require_relative 'lib/results_parser'
require_relative 'lib/match_stats_parser'

get '/api/scores' do
  ResultsParser::get_current_scores.to_json
end

get '/api/scores/:date' do |date|
  ResultsParser::get_scores_for_date(date).to_json
end

get '/api/match/:id' do |id|
  MatchStatsParser::get_match_statistics(id).to_json
end
