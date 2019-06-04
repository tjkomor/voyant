require 'net/http'
require 'uri'
require 'json'
api_key = File.read('api_key.txt')
zip_code = ARGV[0]
uri = URI.parse("http://api.openweathermap.org/data/2.5/weather?zip=#{zip_code}&APPID=#{api_key}")
response = Net::HTTP.get_response(uri)
parsed = JSON.parse(response.body)
description = parsed['weather'].first['description']
temp = parsed['main']['temp_max'].to_s
puts description + ' ' + temp + ' degrees Kelvin'
