require 'sinatra'
# require 'sinatra/reloader'
# require 'pry'
require 'active_record'
require_relative 'db_config'

require_relative 'models/adjective'
require_relative 'models/noun'
require_relative 'models/pair'
require_relative 'models/request'
require_relative 'models/user'

enable :sessions

helpers do
  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  erb :index
end


get '/result' do
  input = params[:user_input]

  if /\d/.match? input
    @digits = input.gsub(' ','')
    if !Pair.exists?(digits: @digits)
      adj_id_arr = Adjective.where.not(id: nil).pluck(:id)
      noun_id_arr = Noun.where.not(id: nil).pluck(:id)

      if Pair.count < 450000
        new_pair_found = false
        while new_pair_found == false do
          a1 = adj_id_arr.sample
          n1 = noun_id_arr.sample
          if Pair.where(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: nil, noun_2_id: nil) == []
            new_pair_found = true
          end
        end
        Pair.create(
          digits: @digits,
          time_stamp: Time.now,
          adjective_1_id: a1,
          noun_1_id: n1,
          access_count: 0
          )

      else

        new_pair_found = false
        while new_pair_found == false do
          a1 = adj_id_arr.sample
          a2 = adj_id_arr.sample
          n1 = noun_id_arr.sample
          if Pair.where(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: a2, noun_2_id: nil) == []
            new_pair_found = true
          end
        end

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
    @phrase = found_pair.phrase

  else

    words = input.split(/ |\.|,|-/)
    if words.length == 2
      a1 = Adjective.find_by(word: words[0]).id

      n1 = Noun.find_by(word: words[1]).id
      found_pair = Pair.find_by(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: nil, noun_2_id: nil)
    end
    if words.length == 3
      a1 = Adjective.find_by(word: words[0]).id
      a2 = Adjective.find_by(word: words[1]).id
      n1 = Noun.find_by(word: words[2]).id
      found_pair = Pair.find_by(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: a2, noun_2_id: nil)
    end
    @digits = found_pair.digits
    @phrase = found_pair.phrase
  end
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
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:pword])
    session[:user_id] = user.id

    redirect '/dashboard'
  else
    @logfail = true
    erb :login
  end
end

get '/dashboard' do
  redirect '/index' unless session[:user_id]
  @user = current_user
  @page = 0
  erb :dashboard
end

get '/dashboard/:ind' do
  redirect '/index' unless session[:user_id]
  @user = current_user
  @page = params[:ind].to_i
  erb :dashboard
end

get '/detail/:id' do
  redirect '/index' unless session[:user_id]
  @req = Request.find(params[:id])
  adj_id_arr = Adjective.where.not(id: nil).pluck(:id)
  noun_id_arr = Noun.where.not(id: nil).pluck(:id)
  new_pair_found = false
  while new_pair_found == false do
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
  redirect "/detail/#{params[:req_id]}"
end
