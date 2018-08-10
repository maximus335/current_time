# frozen_string_literal: true

# Файл инициализации сервиса

require 'logger'

# Корневая директория
$root = File.absolute_path("#{__dir__}/..")

# Отключение буферизации стандартного потока вывода
STDOUT.sync = true

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG
$logger.progname = 'CURRENT_TIME'
$logger.formatter = proc do |severity, time, progname, message|
  "[#{progname}] [#{time.strftime('%F %T')}] #{severity.upcase}: #{message}\n"
end

$lib = "#{$root}/lib"

# Загрузка инициализации составных частей приложения
Dir["#{__dir__}/initializers/*.rb"].sort.each(&method(:require))

