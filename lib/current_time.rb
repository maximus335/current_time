# frozen_string_literal: true

require 'socket'
require 'thread'
require 'json'

module CurrentTime
  class WebServer
    require_relative 'current_time/prepare_response'

    def initialize
      @server = TCPServer.new(8108)
    end

    attr_reader :server

    def self.run!
      new.run
    end

    def run
      loop do
        thread = Thread.new(server.accept) do |session|
          request = session.gets
          next if request.nil?
          path, params = http_parse(request)
          next if path.nil?
          if valid_request?(path)
            $logger.debug "PARAMS   #{params}"
            results = CurrentTime::PrepareResponse.response(params)
            response_process(session, '200', results)
          else
            response_process(session, '400', ['Bad request'])
          end
        end
        thread.value
      end
    end

    private

    def response_process(session, status, results)
      session.print "HTTP/1.1 #{status} Bad Request\r\n" # 1
      session.print "Content-Type: text/html\r\n" # 2
      session.print "\r\n" # 3
      results.each do |result|
        session.print "<h1>#{result}</h1><br />"
      end
      session.close
    end

    def valid_request?(path)
      path.include?('/time')
    end

    def http_parse(request)
      request = request.chomp.force_encoding('utf-8')
      request_map = request.split('?')
      path = request_map.first
      params = request_map.count > 1 ? request_map.last.delete('HTTP/1.1').split(',') : nil
      [path, params]
    end
  end
end
