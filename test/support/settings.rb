# frozen_string_literal: true

module Settings
  def configure_settings(container, options)
    container['settings'].configure do |config|
      options.each do |key, value|
        config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
      end
    end
  end
end
