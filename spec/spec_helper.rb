# frozen_string_literal: true

# Файл поддержки тестирования

require 'rspec'
require 'webmock/rspec'

require_relative '../config/app_init'

Dir["#{$lib}/current_time/**/*.rb"].each(&method(:require))

RSpec.configure do |config|
  # Исключение поддержки конструкций describe без префикса RSpec.
  config.expose_dsl_globally = false
end

spec = File.absolute_path(__dir__)

Dir["#{spec}/shared/**/*.rb"].each(&method(:require))
Dir["#{spec}/support/**/*.rb"].each(&method(:require))
Dir["#{spec}/helpers/**/*.rb"].each(&method(:require))
