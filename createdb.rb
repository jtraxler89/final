# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
require "bcrypt"                                                                      #
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
                  telephone: "847-869-4343",
                  website: "https://www.fiveanddimeevanston.com/",
                  neighborhood: "Evanston")

bars_table.insert(name: "Bangers & Lace",
                  address: "810 Grove St, Evanston, IL 60201",
                  telephone: "847-905-0854",
                  website: "http://www.bangersandlaceevanston.com/",
                  neighborhood: "Evanston")

bars_table.insert(name: "Whiskey Thief Tavern",
                  address: "616 Davis St, Evanston, IL 60201",
                  telephone: "847-859-2342",
                  website: "https://www.whiskeythieftavern.com/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Bat 17",
                  address: "1709 Benson Ave, Evanston, IL 60201",
                  telephone: "847-733-7117",
                  website: "http://bat17evanston.com/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Evanston Pub",
                  address: "1601 Sherman Ave, Evanston, IL 60201",
                  telephone: "847-328-3688",
                  website: "https://www.facebook.com/evanstonpub/",
                  neighborhood: "Evanston")                  

bars_table.insert(name: "Celtic Knot Public House",
                  address: "626 Church St, Evanston, IL 60201",
                  telephone: "847-864-1679",
                  website: "https://www.celticknotpub.com/",
                  neighborhood: "Evanston")                  

users_table = DB.from(:users)

users_table.insert(firstname: "Jeff",
                   lastinitial: "T",
                   homezipcode: "60201",
                   email: "jeff@gmail.com",
                   password: BCrypt::Password.create("jeff123"),
                   periodicupdates: "true")

users_table.insert(firstname: "Jenn",
                   lastinitial: "T",
                   homezipcode: "53211",
                   email: "jenn@gmail.com",
                   password: BCrypt::Password.create("jenn123"),
                   periodicupdates: nil)

users_table.insert(firstname: "John",
                   lastinitial: "T",
                   homezipcode: "53211",
                   email: "john@gmail.com",
                   password: BCrypt::Password.create("john123"),
                   periodicupdates: nil)

reviews_table = DB.from(:reviews)

reviews_table.insert(bar_id: "1",
                     user_id: "1",
                     dayofweek: "Friday",
                     drinkspecials: "4",
                     foodspecials: "4",
                     ambiance: "4",
                     overall: "4",
                     reviewtitle: "Pretty Fly for a Fri-die",
                     comments: "This was such a great place to really turn up on Friday. Way better than the TG.")
                     
reviews_table.insert(bar_id: "1",
                     user_id: "2",
                     dayofweek: "Tuesday",
                     drinkspecials: "5",
                     foodspecials: "5",
                     ambiance: "5",
                     overall: "5",
                     reviewtitle: "It's raining M(en)BAs ",
                     comments: "I loved this place. It was awesome. Still can't believe how many MBAs were there on a Tuesday.")
                    
                     
reviews_table.insert(bar_id: "1",
                     user_id: "3",
                     dayofweek: "Tuesday",
                     drinkspecials: "5",
                     foodspecials: "3",
                     ambiance: "1",
                     overall: "2",
                     reviewtitle: "Isn't Tuesday a school night?",
                     comments: "I cannot believe how many MBA students were out drinking on a Tuesday. Do they not care about grades!!!")