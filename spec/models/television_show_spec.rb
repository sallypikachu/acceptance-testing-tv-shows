require "spec_helper"

describe TelevisionShow do
  let(:television_show) {TelevisionShow.new("Rugrats", "Nickelodeon", "1991", "Rugrats is a show about 4 babies, Tommy Pickles, Chuckie Finster, and Phil and Lil Deville. As we see their lives unravel, we get to hear them talk. On the sidelines are Tommy's mean cousin Angelica, their friend Susie Carmichael (same age as Angelica), and everybody's parents.", "Comedy")}

  describe ".new" do
   it "takes in title, network, starting_year, synopsis, and genre as arguments" do
     expect(television_show).to be_a(TelevisionShow)
   end
 end

 describe "#title" do
   it "returns title" do
     expect(television_show.title).to eq("Rugrats")
   end
 end

 describe "#network" do
   it "returns network" do
     expect(television_show.network).to eq("Nickelodeon")
   end
 end

 describe "#starting_year" do
   it "returns starting_year" do
     expect(television_show.starting_year).to eq("1991")
   end
 end

 describe "#synopsis" do
   it "returns synopsis" do
     expect(television_show.synopsis).to eq("Rugrats is a show about 4 babies, Tommy Pickles, Chuckie Finster, and Phil and Lil Deville. As we see their lives unravel, we get to hear them talk. On the sidelines are Tommy's mean cousin Angelica, their friend Susie Carmichael (same age as Angelica), and everybody's parents.")
   end
 end

 describe "#genre" do
   it "returns genre" do
     expect(television_show.genre).to eq("Comedy")
   end
 end

 describe ".all" do
   it "should return an array of TelevisionShow objects corresponding to the csv data" do
     first_television_show_data = ["Sailor Moon", "Cartoon Network", "1990", "Fighting Evil by Moonlight", "Action"]
     last_television_show_data = ["True Detective", "HBO", "2014", "Thrilling!", "Mystery"]
     CSV.open('television_shows.csv', 'a') do |file|
       file.puts(last_television_show_data)
     end

    television_shows = TelevisionShow.all
    first_television_show = television_shows.first
    first_television_show_attributes = [
      first_television_show.title,
      first_television_show.network,
      first_television_show.starting_year,
      first_television_show.synopsis,
      first_television_show.genre
    ]
    last_television_show = television_shows.last
    last_television_show_attributes = [
      last_television_show.title,
      last_television_show.network,
      last_television_show.starting_year,
      last_television_show.synopsis,
      last_television_show.genre
    ]

    expect(television_shows).to be_a(Array)
    expect(first_television_show).to be_a(TelevisionShow)
    expect(last_television_show).to be_a(TelevisionShow)
    expect(first_television_show_attributes).to eq(first_television_show_data)
    expect(last_television_show_attributes).to eq(last_television_show_data)
  end
end

  describe "#errors" do
    it "should return an empty array for a newly initialized object" do
      expect(television_show.errors).to eq([])
    end
  end

  describe "#valid?" do
    context "for a valid object" do
      it "should return true" do
        expect(television_show.valid?).to eq(true)
      end

      it "should not add any error messages" do
        television_show.valid?
        expect(television_show.errors).to eq([])
      end
    end

    context "for an invalid object" do
      it "should return false" do
        expect(television_show_with_blank_attributes.valid?).to eq(false)
      end

      it "should add an error message if attributes are blank" do
        television_show_with_blank_attributes.valid?
        expect(television_show_with_blank_attributes.errors).to eq(["Please fill in all required fields"])
      end

      it "should add an error message if there is a movie with the same title in the csv" do
        CSV.open('television-shows.csv', 'a') do |file|
          file.puts(["GOT", "HBO", "2011", "Dragons!", "Action"])
        end
        television_show.valid?
        expect(television_show.errors).to eq(["The show has already been added"])
      end

      it "should add both error messages if the object fails both validations" do
        CSV.open('television-shows.csv', 'a') do |file|
          file.puts(["Futurama", "Fox", "1999", "Future!", "Comedy"])
        end
        television_show_with_blank_attributes.valid?
        expect(television_show_with_blank_attributes.errors).to eq(["Please fill in all required fields", "The show has already been added"])
      end
    end
  end

  describe "#save" do
    context "valid object" do
      it "should return true" do
        expect(television_show.save).to eq(true)
      end

      it "should add the attributes to the csv" do
        television_show.save

        television_show_attributes = [
          television_show.title,
          television_show.network,
          television_show.starting_year,
          television_show.synopsis,
          television_show.genre
        ]

        television_shows_data = []
        CSV.foreach("television-shows.csv", headers: true) do |television_show|
          television_shows_data << television_show
        end
        television_show_data = television_shows_data.last.to_hash.values

        expect(television_show_attributes).to eq(television_show_data)
      end
    end

    context "invalid object" do
      it "should return false" do
        expect(television_show_with_blank_attributes.save).to eq(false)
      end

      it "should not add the attributes to the csv" do
        television_show_with_blank_attributes.save

        television_shows_data = []
        CSV.foreach("television-shows.csv", headers: true) do |television_show|
          television_shows_data << television_show
        end

        expect(television_shows_data.size).to eq(0)
      end
    end
  end
end
