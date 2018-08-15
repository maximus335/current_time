# frozen_string_literal: true

require 'tzinfo'

module CurrentTime
  class CitiesTime

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
      city = sanitize_string(city)
      timezone = TZInfo::Timezone.all.find do |tz|
        tz_city = sanitize_string(tz.name.split('/').last)
        tz_city == city
      end
      return 'Not found' unless timezone
      offset = timezone.current_period.offset.utc_total_offset
      Time.now.getlocal(offset).strftime('%d-%m-%Y %H:%M:%S')
    end

    # Преобразует строку в нужный формат
    def sanitize_string(string)
      string.gsub(/[^A-Za-z]+/, '').downcase
    end
  end
end
