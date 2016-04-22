require 'sinatra'
require 'sinatra/reloader'
require './db_config'
require 'active_record'
require 'pg'
require './models/event'
require './models/user'
require 'date'

after do
  ActiveRecord::Base.connection.close
end

enable :sessions

helpers do

  def to_date_string(date_time_obj)
    date_time_obj.strftime('%D')
  end

  def find_user_events
    Event.where(user_id: session[:user_id])
  end

  def get_range(start_day_obj, end_day_obj)
    range = []
    find_user_events.each do | event |
      start_day = start_day_obj.to_i
      end_day = end_day_obj.to_i
      if event.start_time.to_i >= start_day.to_i && event.start_time.to_i <= end_day.to_i
        range.push(event)
      end
    end
    range
  end
end

get '/' do

  if User.all.size == 0
    a = User.new
    a.username = 'chump'
    a.password = 'secret'
    a.save
    b = User.new
    b.username = 'cronos'
    b.password = 'test'
    b.save
  end

  if session[:user_id] == nil
    erb :login
  else
    two_days_later = session[:current_day] + 1.day
    @range = get_range(session[:current_day], two_days_later)
    erb :index
  end
end

get '/error' do
  if session[:user_id] == nil
    erb :login
  else
    erb :error
  end
end

get '/yesterday' do
  session[:current_day] = session[:current_day] - 1.day
  redirect to '/'
end

get '/tomorrow' do
  session[:current_day] = session[:current_day] + 1.day
  redirect to '/'
end

get '/login' do
  erb :login
end

get '/logout' do
  session[:user_id] = nil
  session[:attempt] = false
  erb :login
end

get '/new' do
  if session[:user_id] == nil
    erb :login
  else
    erb :createEvent
  end
end

get '/:id' do
  if session[:user_id] == nil
    erb :login
  else
    @even = Event.find_by(id: params[:id])
    if @even
      erb :details
    else
      erb :createEvent
    end
  end
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
  e.user_id = session[:user_id]
  e.save
end

post '/amend' do
  e = Event.find_by(id: params[:eid])
  start_epoch = params[:start_time]
  end_epoch = params[:end_time]
  e.event_name = params[:event_name]
  e.start_time = DateTime.strptime(start_epoch, '%s')
  e.end_time = DateTime.strptime(end_epoch, '%s')
  e.save
end

delete '/:id' do
  if session[:user_id] == nil
    erb :login
  else
    e = Event.find_by(id: params[:id])
    e.delete
    e.save
    redirect to '/'
  end
end

post '/session' do
  user = User.find_by(username: params[:username].downcase)
  if user && user.authenticate(params[:password])
    session[:current_day] = DateTime.now.to_date.to_time
    session[:username] = user.username
    session[:user_id] = user.id
    session[:attempt] = false
    redirect to '/'
  else
    session[:attempt] = true
    erb :login
  end
end
