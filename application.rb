require 'sinatra'
require 'json'
require_relative 'lib/results_parser'

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
  "Looking for stats for a specific match: #{id}"
end
