# frozen_string_literal: true

module CurrentTime
  class CitiesTime
    require_relative 'cities_time/find_coos'
    require_relative 'cities_time/find_time'

    def initialize(params)
      @cities = params
    end

    attr_reader :cities

    def self.cities_time(params)
      new(params).cities_time
    end

    def cities_time
      cities.each_with_object({}) do |city, memo|
        memo[city] = city_time(city)
      end
    end

    private

    def city_time(city)
      city_coos = FindCoos.find_coos(city)
      FindTime.find_time(city_coos)
    end

  end
end
