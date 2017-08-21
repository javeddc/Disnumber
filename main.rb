require 'sinatra'
require 'active_record'
require_relative 'db_config'
require_relative 'models/adjective'
require_relative 'models/noun'
require_relative 'models/pair'
require_relative 'models/request'
require_relative 'models/user'
enable :sessions

helpers do
  # a helper function which allows other parts of the app to detect wether the user is currently logged in
  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  # finds current user as ActiveRecord object from the session id. returns nil if none found
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/error' do
  erb :error
end

get '/result' do
  # grabs user input search phrase from the query string parameters
  input = params[:user_input].downcase

  # redirect if the input contains any non-alphanumeric characters
  if input.match?(/[^A-Za-z\d +#*-]/)
    @error_input = input
    redirect '/error'
  end

  # redirect if the input contains both letters and numbers
  if input.match?(/\d/) && input.match?(/[A-Za-z]/)
    @error_input = input
    redirect '/error'
  end

  # if the first character is a number, treat input as a phone number
  if /\d/.match? input
    # set 3 variables to be passed to the html view to render a response to the user
    @found = true
    @search_type = 'digits'
    @digits = input.delete(' ')

    # check if the number already has an associated pairing with a phrase in the database
    unless Pair.exists?(digits: @digits)
      # get the ids of valid nouns and adjectives from the database, as arrays of ids
      adj_id_arr = Adjective.where.not(id: nil).pluck(:id)
      noun_id_arr = Noun.where.not(id: nil).pluck(:id)

      # if there are less than 450k pairs, generate a 2-word phrase
      if Pair.count < 450_000
        new_pair_found = false

        # keep generating new phrases until a new phrase is found
        while new_pair_found == false
          a1 = adj_id_arr.sample
          n1 = noun_id_arr.sample
          if Pair.where(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: nil, noun_2_id: nil) == []
            new_pair_found = true
          end
        end

        # create a new pair record which connects the number and the newly generated phrase
        Pair.create(
          digits: @digits,
          time_stamp: Time.now,
          adjective_1_id: a1,
          noun_1_id: n1,
          access_count: 0
        )

      # if there are more than 450k pairs, generate a 3-word phrase
      else
        new_pair_found = false
        # loops to find a 3 word phrase that hasn't been used yet
        while new_pair_found == false
          a1 = adj_id_arr.sample
          a2 = adj_id_arr.sample
          n1 = noun_id_arr.sample
          if Pair.where(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: a2, noun_2_id: nil) == []
            new_pair_found = true
          end
        end
        # creates a pairing of the generated phrase and the input number
        Pair.create(
          digits: @digits,
          time_stamp: Time.now,
          adjective_1_id: a1,
          adjective_2_id: a2,
          noun_1_id: n1,
          access_count: 0
        )
      end
    end
    found_pair = Pair.where(digits: @digits).order('time_stamp ASC').last
    found_pair.access_count += 1
    found_pair.save
    # saves the phrase to a variable that can be passed to the view html template
    @phrase = found_pair.phrase
  else
    # tells the view template that the search was a phrase
    @search_type = 'phrase'
    # splits the phrase into words by spaces
    words = input.split(/ |\.|,|-/)

    # if it's two words long look for relevant number-phrase pairings
    if words.length == 2
      # searches for the ids of the adjective and noun
      if Adjective.exists?(word: words[0]) && Noun.exists?(word: words[1])
        a1 = Adjective.find_by(word: words[0]).id
        n1 = Noun.find_by(word: words[1]).id
        found_pair = Pair.find_by(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: nil, noun_2_id: nil)
      else
        found_pair = nil
      end
    end

    # if it's 3 words long look for relevant pairings
    if words.length == 3
      # search the lists of adjectives and nouns for the input words
      if Adjective.exists?(word: words[0]) && Adjective.exists?(word: words[1]) && Noun.exists?(word: words[2])
        a1 = Adjective.find_by(word: words[0]).id
        a2 = Adjective.find_by(word: words[1]).id
        n1 = Noun.find_by(word: words[2]).id
        found_pair = Pair.find_by(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: a2, noun_2_id: nil)
      else
        found_pair = nil
      end
    end

    # if a pairing was found, parse it into variables to be passed to the view
    if !found_pair.nil?
      @digits = found_pair.digits
      @phrase = found_pair.phrase
      @found = true
    else
      # if a pairing wasn't found, pass variables that allow the view to display an error
      @input = input
      @found = false
    end
  end
  # render the result view
  erb :result
end

get '/request' do
  @flagged_pair = Pair.find(params[:pair_id])
  erb :request
end

post '/request' do
  r1 = Request.create(request_type: params[:request_type], status: 'open', pair_id: params[:pair_id], email: params[:email], message: params[:message], time_stamp: Time.now, digits: params[:digits])
  @confirmed_id = r1.id
  @digits = Pair.find(params[:pair_id]).digits
  erb :thanks
end

get '/login' do
  @logfail = false
  erb :login
end

post '/session' do
  # searches the database of admin users for a matching email
  user = User.find_by(email: params[:email])
  # if a user found, and that user's password digest matches the digested input password, create a new session
  if user && user.authenticate(params[:pword])
    session[:user_id] = user.id
    redirect '/dashboard'
  else
    # pass a variable to the view that can display an error in the login view
    @logfail = true
    erb :login
  end
end

get '/dashboard' do
  # redirect unless a matching session is found
  redirect '/index' unless session[:user_id]
  # give current user and page number to view
  @user = current_user
  @page = 0
  erb :dashboard
end

get '/dashboard/:ind' do
  redirect '/index' unless session[:user_id]
  @user = current_user
  # parse query string into index number for rendering the results view
  @page = params[:ind].to_i
  erb :dashboard
end

get '/detail/:id' do
  # redirect unless admin
  redirect '/index' unless session[:user_id]
  # find the relevant flag request from the query string
  @req = Request.find(params[:id])
  # find the ids of valid adjectives and nouns
  adj_id_arr = Adjective.where.not(id: nil).pluck(:id)
  noun_id_arr = Noun.where.not(id: nil).pluck(:id)
  new_pair_found = false

  # generate new adjective-noun pairs until a new one is found
  while new_pair_found == false
    @rand_adj_1 = adj_id_arr.sample
    @rand_adj_2 = adj_id_arr.sample
    @rand_noun_1 = noun_id_arr.sample
    if Pair.where(adjective_1_id: @rand_adj_1, noun_1_id: @rand_noun_1, adjective_2_id: @rand_adj_2, noun_2_id: nil) == []
      new_pair_found = true
    end
  end
  erb :detail
end

post '/record' do
  # redirect unless admin
  redirect '/index' unless session[:user_id]
  # if it's a two-word phrase, save a new two-word pairing
  if params[:pair_size].to_i == 2
    Pair.create(
      digits: params[:digits],
      time_stamp: Time.now,
      adjective_1_id: params[:rand_adj_1],
      noun_1_id: params[:rand_noun_1],
      access_count: 0
    )
    req = Request.find(params[:req_id])
    req.status = 'closed'
    req.save
  # if it's a three-word phrase, save a new three-word pairing
  elsif params[:pair_size].to_i == 3
    Pair.create(
      digits: params[:digits],
      time_stamp: Time.now,
      adjective_1_id: params[:rand_adj_1],
      adjective_2_id: params[:rand_adj_2],
      noun_1_id: params[:rand_noun_1],
      access_count: 0
    )
    end
  # redirect to detail of the created pairing to protect the post route
  redirect "/detail/#{params[:req_id]}"
end
