require 'net/http'
require 'uri'

namespace :konbini do
  desc "Calling mapbox api to create konbini"
  task seed: :environment do
    areas = ["139.7038,35.6620", "139.749460,35.686960"]
    areas.each do |area|
      uri = URI.parse("https://api.mapbox.com/geocoding/v5/mapbox.places/convenience%20store.json?types=poi&proximity=#{area}&access_token=#{ENV['MAPBOX_API_KEY']}")
      response = Net::HTTP.get_response(uri)

      list = JSON.parse(response.body)
      list["features"].each do |feature|
        features_hash = {}
        features_hash[:mapbox_id] = feature["id"]
        features_hash[:name] = feature["text"]
        features_hash[:address] = feature["place_name"]
        features_hash[:latitude] = feature["center"][0]
        features_hash[:longitude] = feature["center"][1]
        Konbini.create(features_hash)
      end
    end
  end
end
