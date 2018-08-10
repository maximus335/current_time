# encoding: utf-8

require 'rest-client'

module CurrentTime
  class CitiesTime
    # Класс запросов к сервису Яндекса для получения информации о
    # географических координатах города
    class FindCoos
      # Создаёт объект класса и с его помощью осуществляет запрос,
      # извлекает информацию о географических координатах города и
      # возвращает список с географической широтой и географической
      # долготой города. Если информация о городе отсутствует, то
      # возвращает `nil`. В случае ошибки во время осуществления
      # запроса или обработки его результата также возвращает `nil`
      # @param [#to_s] address
      #   объект с информацией о городе
      # @return [Array<(String, String)>]
      #   список из географической широты и географической долготы города
      # @return [NilClass]
      #   если информация о городе отсутствует или произошла
      #   ошибка при осуществлении запроса или обработке его
      #   результата.
      def self.find_coos(city)
        new(city).find_coos
      end

      # Инициализирует объект класса
      # @param [#to_s] address
      #   объект с информацией о городе
      def initialize(city)
        @city = city.to_s.gsub(/%20/, '+')
      end

      # URL сервиса Яндекса определения географических координат
      # объекта
      URL = 'https://geocode-maps.yandex.ru/1.x'

      # Путь в структуре, возвращаемой API Яндекса, до географических
      # координат объекта
      POINT_PATH = [
        :response,
        :GeoObjectCollection,
        :featureMember,
        0,
        :GeoObject,
        :Point,
        :pos
      ]

      # Осуществляет запрос, извлекает информацию о географических
      # координатах города и возвращает список с географической широтой и
      # географической долготой города. Если информация о городе
      # отсутствует, то возвращает `nil`. В случае ошибки во время
      # осуществления запроса или обработки его результата также
      # возвращает `nil`
      # @return [Array<(String, String)>]
      #   список из географической широты и географической долготы города
      # @return [NilClass]
      #   если информация о городе отсутствует или произошла
      #   ошибка при осуществлении запроса или обработке его
      #   результата.
      def find_coos
        return if city.empty?
        request_params = { format: :json, geocode: city }
        response = RestClient.get(URL, params: request_params)
        data = JSON.parse(response.body, symbolize_names: true)
        point = data.dig(*POINT_PATH)
        point.split(' ')
      rescue
        nil
      end

      private
      # Строка с наименованием города
      # @return [String]
      #   строка с адресом УИК
      attr_reader :city
    end
  end
end
