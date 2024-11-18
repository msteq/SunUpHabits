require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SunUpHabits
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # タイムゾーンを日本標準時に設定
    config.time_zone = "Tokyo"

    # Active Recordにもタイムゾーンを適用
    config.active_record.default_timezone = :local

    # デフォルトのロケールを日本語に設定
    config.i18n.default_locale = :ja

    # 使用可能なロケールを日本語に設定
    config.i18n.available_locales = [:ja]

    # 日本語のロケールファイルをロードパスに追加
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]

    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.test_framework nil
    end
  end
end
