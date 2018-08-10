# frozen_string_literal: true

module CurrentTime
  class PrepareResponse
    require_relative 'cities_time'

    def initialize(params)
      @params = params || []
    end

    attr_reader :params

    def self.response(params)
      new(params).response
    end

    def response
      case params.count
      when 0
        ["UTC: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"]
      else
        cities_time = CurrentTime::CitiesTime.cities_time(params)
        result(cities_time)
      end
    end

    private

    def result(cities_time)
      utc = "UTC: #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      cities_time.each_with_object([utc]) do |(key, value), memo|
        city = key.gsub(/%20/, ' ')
        memo << "#{city}: #{value}"
      end
    end
  end
end
