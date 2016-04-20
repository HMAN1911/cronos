require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require './db_config'
require 'active_record'
require 'pg'
require './models/event'
require 'Date'

after do
  ActiveRecord::Base.connection.close
end

helpers do

  @today = DateTime.now
  
  def to_date_string(date_time_obj)
    date_time_obj.strftime('%D')
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
end

get '/' do
  @range = get_range(DateTime.now.to_date.to_time - 1.day, DateTime.now.to_date.to_time + 1.day)
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