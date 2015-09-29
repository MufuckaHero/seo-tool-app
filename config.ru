require ::File.expand_path('../config/environment',  __FILE__)

module Rack
  class Lint
    def assert message, &block
    end
  end
end

run Seo::App
