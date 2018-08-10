# encoding: utf-8

require 'tzinfo'
require 'wheretz'

module CurrentTime
  class CitiesTime
    # Класс запросов к сервису Яндекса для получения информации о
    # географических координатах города
    class FindTime
      # Создаёт объект класса и с его помощью осуществляет запрос,
      # извлекает информацию о временной зоне
      # города
      # @param [Array] coos
      #   объект с информацией координатах города
      # @return [String]
      #   текущее время в городе
      # @return [NilClass]
      #   если информация о городе отсутствует или произошла
      #   ошибка при осуществлении запроса или обработке его
      #   результата.
      def self.find_time(coos)
        new(coos).find_time
      end

      # Инициализирует объект класса
      # @param [Array] coos
      #   объект с информацией координатах города
      def initialize(coos)
        @coos = coos
      end

      # Осуществляет запрос, извлекает информацию о временной зоне
      # города
      # @return [String]
      #   текущее время в городе
      # @return [NilClass]
      #   если информация о городе отсутствует или произошла
      #   ошибка при осуществлении запроса или обработке его
      #   результата.
      def find_time
        return not_found if coos.nil?
        lat = coos[1].to_f
        lng = coos[0].to_f
        timezone_name = WhereTZ.lookup(lat, lng)
        timezone = TZInfo::Timezone.get(timezone_name)
        offset = timezone.current_period.offset.utc_total_offset

        Time.now.getlocal(offset).strftime("%Y-%m-%d %H:%M:%S")
      end

      private
      # Строка с наименованием города
      # @return [Array]
      #   объект с информацией координатах города
      attr_reader :coos

      def not_found
        'Not found'
      end
    end
  end
end
