# frozen_string_literal: true

load "#{__dir__}/config/app_init.rb"
load "#{__dir__}/lib/current_time/web_server.rb"

CurrentTime::WebServer.run!
