require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require './db_config'
require 'active_record'
require 'pg'
require './models/event'
require './models/user'
require 'Date'

after do
  ActiveRecord::Base.connection.close
end

enable :sessions

helpers do
  
  def to_date_string(date_time_obj)
    date_time_obj.strftime('%D')
  end

  def find_user_events()
    Event.where(user_id: session[:user_id])
  end

  def get_range(start_day_obj, end_day_obj)
    range = []
    Event.all.each do | event |
      start_day = start_day_obj.to_i
      end_day = end_day_obj.to_i
      if event.start_time.to_i >= start_day.to_i && event.start_time.to_i <= end_day.to_i
        range.push(event)
      end
    end
      range
  end

  def default_view
    get_range(DateTime.now.to_date.to_time, DateTime.now.to_date.to_time + 1.day)
  end
end

get '/' do
  if session[:user_id] == nil
    erb :login
  else 
    @range = default_view
    erb :index
end

get '/error' do
  erb :error
end



get '/createEvent' do
  erb :createEvent
end

post '/results' do
  e = Event.new
  start_epoch = params[:start_time]
  end_epoch = params[:end_time]
  timestamp = params[:create_time]
  e.event_name = params[:event_name]
  e.start_time = DateTime.strptime(start_epoch, '%s')
  e.end_time = DateTime.strptime(end_epoch, '%s')
  e.create_time = DateTime.strptime(timestamp, '%s')
  e.save
end

post '/session' do
  user = User.find_by(username: params[:email].downcase)
  if user && user.authenticate(params[:password])
    session[:username] = user.username
    session[:user_id] = user.id
    redirect to '/'
  else
    session[:attempt] = true
    erb :login
  end
end