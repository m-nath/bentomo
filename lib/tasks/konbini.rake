require 'net/http'
require 'uri'

namespace :konbini do
  desc "Calling google api to create konbini"
  task seed: :environment do
    areas = ["Meguro"]
    areas.each do |area|
      uri = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=convenience+stores+in+#{area}&key=#{ENV['GOOGLEMAP_API_KEY']}")
      response = Net::HTTP.get_response(uri)

      list = JSON.parse(response.body)
      list["results"].each do |result|
        results_hash = {}
        results_hash[:mapbox_id] = result["id"]
        results_hash[:name] = result["name"]
        results_hash[:address] = result["formatted_address"]
        results_hash[:latitude] = result["geometry"]["location"]["lat"]
        results_hash[:longitude] = result["geometry"]["location"]["lng"]
        Konbini.create(results_hash)
        p results_hash
      end
    end
  end
end
