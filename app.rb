# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

bars_table = DB.from(:bars)
reviews_table = DB.from(:reviews)
users_table = DB.from(:users)

get "/" do 
    @bars = bars_table.all
    puts @bars.inspect
    view "bars"
end

get "/bars/:id" do
    # SELECT * FROM bars WHERE id=:id
    @bar = bars_table.where(:id => params["id"]).to_a[0]
    @reviews = reviews_table.where(:bars_id => params["id"]).to_a
    @reviewsCTdayofweekM = reviews_table.where(:bars_id => params["id"], :dayofweek => "Monday").count
    @reviewsCTdayofweekTu = reviews_table.where(:bars_id => params["id"], :dayofweek => "Tuesday").count
    @reviewsCTdayofweekW = reviews_table.where(:bars_id => params["id"], :dayofweek => "Wednesday").count
    @reviewsCTdayofweekTh = reviews_table.where(:bars_id => params["id"], :dayofweek => "Thursday").count
    @reviewsCTdayofweekF = reviews_table.where(:bars_id => params["id"], :dayofweek => "Friday").count
    @reviewsCTdayofweekSa = reviews_table.where(:bars_id => params["id"], :dayofweek => "Saturday").count
    @reviewsCTdayofweekSu = reviews_table.where(:bars_id => params["id"], :dayofweek => "Sunday").count
    @reviewsAVGdrinkspecials = reviews_table.where(:bars_id => params["id"]).avg(:drinkspecials)
    @reviewsAVGfoodspecials = reviews_table.where(:bars_id => params["id"]).avg(:foodspecials)
    @reviewsAVGambiance = reviews_table.where(:bars_id => params["id"]).avg(:ambiance)
    @reviewsAVGoverall = reviews_table.where(:bars_id => params["id"]).avg(:overall)
    puts @bar.inspect
    puts params.inspect
    view "bar"
end

get "/bars/:id/reviews/new" do
    @bar = bars_table.where(:id => params["id"]).to_a[0]
    view "new_review"
end

get "/bars/:id/reviews/create" do
    puts params.inspect
    reviews_table.insert(:bars_id => params["id"],
                         :dayofweek => params["dayofweek"],
                         :drinkspecials => params["drinkspecials"],
                         :foodspecials => params["foddspecials"],
                         :ambiance => params["ambiance"],
                         :overall => params["overall"],
                         :firstname => params["firstname"],
                         :lastinitial => params["lastinitial"],
                         :email => params["email"],
                         :reviewtitle => params["reviewtitle"],
                         :comments => params["comments"])
    "Thank you for your review!"
end
