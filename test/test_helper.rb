ENV['RAILS_ENV'] = 'test'
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "active_model/railtie"

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.deprecation = :stderr

    if config.respond_to?(:active_model)
      config.active_model.i18n_customize_full_message = true
    end
  end
end

Dummy::Application.initialize!

require "active_record"

class Book < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.verbose = false

load "#{File.dirname(__FILE__)}/support/schema.rb"

I18n.load_path << Dir['fixtures/locales/*.yml']
I18n.backend.load_translations

require "warning_ignore"
require "minitest/autorun"
require "super_tools"
require "shoulda-context"
require "helpers/build_orders_helper"
require "reform/rails"

Reform::Rails::Railtie.active_model!
