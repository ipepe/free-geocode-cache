require 'sinatra'
require 'sinatra/cross_origin'
require 'pry'
require 'json'
require 'geocoder'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'database.sqlite3')
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Search < ActiveRecord::Base
  validates_presence_of :key, :latitude, :longitude

  def self.lookup(query)
    query = query.downcase
    if (result = Search.find_by(key: query)).present?
      result
    else
      sleep(1)
      puts "Geocoder searching for #{query}..."
      coords = Geocoder.search(query).first.try(:coordinates)
      Search.create(key: query, coordinates: coords)
    end
  end
  def coordinates=(coords)
    self.latitude = coords[0]
    self.longitude = coords[1]
  end
  def geojson
    {
        "type": "Feature",
        "properties": {
            "name": self.key
        },
        "geometry": {
            "type": "Point",
            "coordinates": [self.longitude.to_f, self.latitude.to_f]
        }
    }
  end
end

unless ActiveRecord::Base.connection.table_exists?(:searches)
  ActiveRecord::Migration.class_eval do
    create_table :searches do |t|
      t.string  :key
      t.decimal :latitude
      t.decimal :longitude
    end
  end
end