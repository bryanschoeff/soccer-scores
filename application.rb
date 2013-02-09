require 'sinatra'
require 'json'
require_relative 'lib/results_parser'
require_relative 'lib/match_stats_parser'

get '/' do
  'Up and running'
end

get '/api/scores' do
  ResultsParser::get_current_scores.to_json
end

get '/api/scores/:date' do |date|
  "Looking for scores for a specific date: #{date}"
end

get '/api/match/:id' do |id|
  MatchStatsParser::get_match_statistics(id).to_json
end
