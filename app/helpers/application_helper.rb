# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # google map api key
  def google_map_api_key
    if ENV['RAILS_ENV']=='production'
      return 'ABQIAAAAjW5WlpUIeJ4V20Ugy3cV7xQhaSa8QL5QrdddfZ1_rxQDW6FCVBQMMBp-vaNyRB084BdslWwnR0pikg'
    else
      return 'ABQIAAAAjW5WlpUIeJ4V20Ugy3cV7xTJQa0g3IQ9GZqIMmInSLzwtGDKaBS8ZMLP56avcfZpzth_cRun9GQq7Q'
    end
  end
end
