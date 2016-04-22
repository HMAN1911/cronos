require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'time'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
