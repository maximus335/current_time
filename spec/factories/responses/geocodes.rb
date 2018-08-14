# frozen_string_literal: true

# Фабрика тела ответа на запрос к API Яндекса на получение информации о
# координатах объекта

FactoryBot.define do
  factory 'responses/geocode', class: String do
    lat { rand * 100.0 }
    lng { rand * 100.0 }
    skip_create
    initialize_with do
      {
        response: {
          GeoObjectCollection: {
            featureMember: [
              {
                GeoObject: {
                  Point: {
                    pos: "#{lng} #{lat}"
                  }
                }
              }
            ]
          }
        }
      }.to_json
    end
  end
end
