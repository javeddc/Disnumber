require 'sinatra'
require 'sinatra/reloader'
require 'pry'
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
  numchars = ('0'..'9').to_a
  if numchars.include? input[0]
    @digits = input.gsub(' ','')
    if !Pair.exists?(digits: @digits)
      return erb :error
    end
    @phrase = Pair.find_by(digits: @digits).phrase

  else
    words = input.split(/ |\.|,|-/)
    a1 = Adjective.find_by(word: words[0]).id
    n1 = Noun.find_by(word: words[1]).id
    a2 = Adjective.find_by(word: words[2]).id
    n2 = Noun.find_by(word: words[3]).id
    found_pair = Pair.find_by(adjective_1_id: a1, noun_1_id: n1, adjective_2_id: a2, noun_2_id: n2)
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
  erb :detail
end
