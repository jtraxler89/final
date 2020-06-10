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



before do
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end

get "/" do 
    @bars = bars_table.all
    @bars_table = bars_table
    @reviews_table = reviews_table
    puts @bars.inspect
    view "bars"
end

get "/bars/new" do
    puts params.inspect
    view "new_bar"
end

post "/bars/create" do
    puts params.inspect
    bar = bars_table.where(:id => params["id"]).to_a[0]
    telephone_entered = params["telephone"]
    telephone = bars_table.where(:telephone => telephone_entered).to_a[0]
    if telephone && (telephone[:telephone] == telephone_entered)
        view "create_bar_failed"
    else
        bars_table.insert(:name => params["name"],
                          :address => params["address"],
                          :telephone => params["telephone"],
                          :website => params["website"],
                          :neighborhood => params["neighborhood"])
        view "create_bar"
    end    
end

get "/bars/:id" do
    # SELECT * FROM bars WHERE id=:id
    @bar = bars_table.where(:id => params["id"]).to_a[0]
    @reviews = reviews_table.where(:bar_id => params["id"]).to_a
    @reviews_table = reviews_table
    @users_table = users_table
    @reviewsCTdayofweekM = reviews_table.where(:bar_id => params["id"], :dayofweek => "Monday").count
    @reviewsCTdayofweekTu = reviews_table.where(:bar_id => params["id"], :dayofweek => "Tuesday").count
    @reviewsCTdayofweekW = reviews_table.where(:bar_id => params["id"], :dayofweek => "Wednesday").count
    @reviewsCTdayofweekTh = reviews_table.where(:bar_id => params["id"], :dayofweek => "Thursday").count
    @reviewsCTdayofweekF = reviews_table.where(:bar_id => params["id"], :dayofweek => "Friday").count
    @reviewsCTdayofweekSa = reviews_table.where(:bar_id => params["id"], :dayofweek => "Saturday").count
    @reviewsCTdayofweekSu = reviews_table.where(:bar_id => params["id"], :dayofweek => "Sunday").count
    @reviewsAVGdrinkspecials = reviews_table.where(:bar_id => params["id"]).avg(:drinkspecials)
    @reviewsAVGfoodspecials = reviews_table.where(:bar_id => params["id"]).avg(:foodspecials)
    @reviewsAVGambiance = reviews_table.where(:bar_id => params["id"]).avg(:ambiance)
    @reviewsAVGoverall = reviews_table.where(:bar_id => params["id"]).avg(:overall)
    @address = @bar[:address]
    results = Geocoder.search(@address)
    @lat_long = results.first.coordinates.join(",")
    puts @bar.inspect
    puts params.inspect
    view "bar"
end

get "/bars/:id/reviews/new" do
    @bar = bars_table.where(:id => params["id"]).to_a[0]   
    view "new_review"
end

post "/bars/:id/reviews/create" do
    puts params.inspect
    @bar = bars_table.where(:id => params["id"]).to_a[0]
    if @current_user == nil
        view "create_review_failed"
    else
        reviews_table.insert(:bar_id => params["id"],
                             :dayofweek => params["dayofweek"],
                             :drinkspecials => params["drinkspecials"],
                             :foodspecials => params["foodspecials"],
                             :ambiance => params["ambiance"],
                             :overall => params["overall"],
                             :user_id => @current_user[:id],
                             :reviewtitle => params["reviewtitle"],
                             :comments => params["comments"])
        view "create_review"
    end    
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    puts params.inspect
    email_entered = params["email"]
    password_entered = params["password"]
    user = users_table.where(:email => email_entered).to_a[0]
    if user && (user[:email] == email_entered)
        view "create_user_failed"
    else
        users_table.insert(:firstname => params["firstname"],
                           :lastinitial => params["lastinitial"],
                           :homezipcode => params["homezipcode"],
                           :email => params["email"],
                           :password => BCrypt::Password.create(params["password"]),
                           :periodicupdates => params["periodicupdates"])
        
        account_sid = ENV["TWILIO_ACCOUNT_SID"]
        puts #{account_sid}
        auth_token = ENV["TWILIO_AUTH_TOKEN"]
        client = Twilio::REST::Client.new(account_sid, auth_token)

        from = "+12058392574" 
        to = "+14148702846"

        client.messages.create(
        from: from, 
        to: to,
        body: "A new user has been created on The Happiest Hour!")
        
        view "create_user"
    end
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    user = users_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        if BCrypt::Password.new(user[:password]) == password_entered
            session[:user_id] = user[:id]
            view "create_login"
        else
            view "create_login_failed"
        end
    else
        view "create_login_failed"
    end
end

get "/logout" do
    session[:user_id] = nil 
    view "logout"
end