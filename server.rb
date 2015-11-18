require 'sinatra'
require 'csv'
require_relative "app/models/television_show"
require 'pry'

set :views, File.join(File.dirname(__FILE__), "app/views")

before do
  @shows = []

  CSV.foreach('television_shows.csv', headers: true, header_converters: :symbol) do |row|
    show = row.to_hash
    @shows << show
  end
end

get '/television_shows' do
  erb :index
end

get '/television_shows/new' do
  erb :new
end

post '/television_shows/new' do
  title = params['title']
  network = params['network']
  starting_year = params['starting_year']
  synopsis = params['synopsis']
  genre = params['Genre']

  data = [title, network, starting_year, synopsis, genre]

  @boolean = false
  @shows.each {|show| @boolean = true if show.values.include?(title)}

  if data.any? { |item| item == nil || item == ""}
    @not_filled = true
    erb :new
  elsif @boolean
    erb :new
  else
    CSV.open('television_shows.csv', 'a') do |file|
      file << data
    end
    redirect '/television_shows'
  end
end
