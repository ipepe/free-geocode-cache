require './setup'

metro_stations = ["Kabaty", "Natolin", "Imielin", "Stokłosy", "Ursynów", "Służew", "Wilanowska", "Wierzbno",
                  "Racławicka", "Pole Mokotowskie", "Politechnika", "Plac Konstytucji", "Centrum",
                  "Świętokrzyska", "Ratusz Arsenał", "Muranów", "Dworzec Gdański", "Plac Wilsona", "Marymont",
                  "Słodowiec", "Stare Bielany", "Wawrzyszew", "Młociny"]

configure do
  enable :cross_origin
end

get '/geocoder/metro_stations' do
  content_type('application/json')
  metro_stations.map do |name|
    Search.lookup("Warszawa, Metro #{name}").geojson
  end.to_json
end

get '/geocoder' do
  content_type('application/json')
  Search.lookup(params['query'] || 'Warszawa, Centrum').to_json
end

# binding.pry
