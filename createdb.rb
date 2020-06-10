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
  foreign_key :bar_id
  foreign_key :user_id
  String :dayofweek
  Integer :drinkspecials
  Integer :foodspecials
  Integer :ambiance
  Integer :overall
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
  Boolean :periodicupdates
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
                  address: "616 Davis St, Evanston, IL 60201",
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
