class TelevisionShow
  GENRES = ["Action", "Mystery", "Drama", "Comedy", "Fantasy"]

  attr_reader :title, :network, :starting_year, :synopsis, :genre

  def initialize(title, network, starting_year, synopsis, genre)
    @title = title
    @network = network
    @starting_year = starting_year
    @synopsis = synopsis
    @genre = genre
  end

  def self.all
    #class method
    #return an array of TelevisionShow objects whose attributes correspond to each data row in the csv file
    @shows = []

    CSV.foreach('television_shows.csv', headers: true, header_converters: :symbol) do |row|
      show = row.to_hash
      @shows << show
    end

    @shows.map do |show|
      TelevisionShow.new(
      show[:title],
      show[:network],
      show[:starting_year],
      show[:synopsis],
      show[:genre],
      )
    end
  end

  def errors
    #on a newly initialized object, this method should return an empty array
  end

  def valid?

  end
end
