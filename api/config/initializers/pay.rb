# typed: strict

Pay.setup do |config|
  config.default_product_name = "default"
  config.default_plan_name = "default"
  config.automount_routes = true
  config.routes_path = "/pay"
  config.enabled_processors = [ :stripe ]
  config.send_emails = false
end
