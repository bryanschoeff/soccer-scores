require 'sinatra'

get '/' do
  'Up and running'
end

get '/api/scores' do
  'Looking for current scores'
end

get '/api/scores/:date' do |date|
  "Looking for scores for a specific date: #{date}"
end

get '/api/match/:id' do |id|
  "Looking for stats for a specific match: #{id}"
end
