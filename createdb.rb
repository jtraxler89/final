# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :bars do
  primary_key :id
  String :name
  String :address, text: true
  String :telephone
  String :website
  String :neighborhood
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :bars_id
  foreign_key2 :users_id
  String :dayofweek
  Integer :drinkspecials
  Integer :foodspecials
  Integer :ambiance
  Integer :overall
  String :firstname
  String :lastinitial
  String :email
  String :reviewtitle
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :firstname
  String :lastinitial
  String :homezipcode
  String :email
  String :password
  Boolean :weeklyupdate
end

# Insert initial (seed) data
bars_table = DB.from(:bars)

bars_table.insert(name: "Five & Dime",
                  address: "1026 Davis St, Evanston, IL 60201",
                  telephone: "(847) 869-4343",
                  website: "https://www.fiveanddimeevanston.com/",
                  neighborhood: "Evanston")

bars_table.insert(name: "Bangers & Lace",
                  address: "810 Grove St, Evanston, IL 60201",
                  telephone: "(847) 905-0854",
                  website: "http://www.bangersandlaceevanston.com/",
                  neighborhood: "Evanston")

bars_table.insert(name: "Whiskey Thief Tavern",
                  address: "616 DAvis St, Evanston, IL 60201",
                  telephone: "(847) 859-2342",
                  website: "https://www.whiskeythieftavern.com/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Bat 17",
                  address: "1709 Benson Ave, Evanston, IL 60201",
                  telephone: "(847) 733-7117",
                  website: "http://bat17evanston.com/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Evanston Pub",
                  address: "1601 Sherman Ave, Evanston, IL 60201",
                  telephone: "(847) 328-3688",
                  website: "https://www.facebook.com/evanstonpub/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Celtic Knot Public House",
                  address: "626 Chirch St, Evanston, IL 60201",
                  telephone: "(847) 864-1679",
                  website: "https://www.celticknotpub.com/",
                  neighborhood: "Evanston")                  

reviews_table = DB.from(:reviews)

reviews_table.insert(bars_id: 1,
                     dayofweek: "Friday",
                     drinkspecials: 5,
                     foodspecials: 5,
                     ambiance: 5,
                     overall: 5,
                     firstname: "Jeff",
                     lastinitial: "T",
                     email: "jtraxler89@gmail.com",
                     reviewtitle: "CRUSHED IT",
                     comments: "That rooftop is sick. And they really had their social distancing down.")

reviews_table.insert(bars_id: 1,
                     dayofweek: "Tuesday",
                     drinkspecials: 2,
                     foodspecials: 2,
                     ambiance: 2,
                     overall: 2,
                     firstname: "John",
                     lastinitial: "T",
                     email: "jtraxler@wi.rr.com",
                     reviewtitle: "YUCK!!",
                     comments: "There were so many MBA students going crazy...")