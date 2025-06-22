# typed: strict

Blueprinter.configure do |config|
  config.extensions << BlueprinterActiveRecord::Preloader.new(auto: true)
end
