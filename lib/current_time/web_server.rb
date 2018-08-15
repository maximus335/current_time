# frozen_string_literal: true

require 'socket'
require 'thread'

module CurrentTime
  class WebServer
    require_relative 'prepare_response'

    def initialize
      @server = TCPServer.new(8108)
    end

    attr_reader :server

    # Создаёт объект класса и запускает web сервер
    def self.run!
      new.run
    end

    # Запускает web сервер
    def run
      loop do
        Thread.start(server.accept) do |session|
          begin
            request = session.gets
            next unless request
            path, params = http_parse(request)
            next unless path
            if rout_match?(path)
              results = CurrentTime::PrepareResponse.response(params)
              response_process(session, '200', results)
            else
              response_process(session, '400', ['Bad request'])
            end
          rescue => e
            $logger.error("#{e.class}: #{e.message}")
            response_process(session, '500', ['Internal Server Error'])
          end
        end
      end
    end

    private

    # Формирует ответ на http запрос
    # @params [TCPSocket] session
    #  сокет
    # @params [String] status
    #  http статус ответа
    # @params [Array] results
    #  тело ответа
    def response_process(session, status, results)
      session.print "HTTP/1.1 #{status} Bad Request\r\n" # 1
      session.print "Content-Type: text/html\r\n" # 2
      session.print "\r\n" # 3
      results.each do |result|
        session.print "<h1>#{result}</h1><br />"
      end
      session.close
    end

    # Проверяет валидность роута
    # @return [Boolean]
    #  результат проверки
    def rout_match?(path)
      path == '/time'
    end

    # Возвращает path и params http запроса
    # @params [String] request
    #  запрос
    # @return [Array]
    #  path и params http запроса
    def http_parse(request)
      request = request.chomp.split(' ')[1]
      $logger.debug(request)
      uri = URI.parse(request)
      query = uri.query
      path = uri.path
      params = URI.decode(query).split(',') if query
      [path, params]
    end
  end
end
