# frozen_string_literal: true

module CurrentTime
  class CitiesTime
    require_relative 'cities_time/find_coos'
    require_relative 'cities_time/find_time'

    def initialize(params)
      @cities = params
    end

    attr_reader :cities

    # Инициализирует объект класса, и возвращает ассоциативный массив
    # с временем городов переданных в параметрах
    # @params [Array] params
    #  список городов
    # @return [Hash]
    #  ассоциативный массив с временем городов переданных в параметрах
    def self.cities_time(params)
      new(params).cities_time
    end

    # возвращает ассоциативный массивс временем городов
    # переданных в параметрах
    # @return [Hash]
    #  ассоциативный массив с временем городов переданных в параметрах
    def cities_time
      cities.each_with_object({}) do |city, memo|
        memo[city] = city_time(city)
      end
    end

    private

    # Возвращает время для города переданого в аргументе
    # @params [String] city
    #  название города
    # @return [String]
    #  время города
    def city_time(city)
      city_coos = FindCoos.find_coos(city)
      city_coos.nil? ? 'Not found' : FindTime.find_time(city_coos)
    end

  end
end
