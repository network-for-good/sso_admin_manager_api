require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
Rails.backtrace_cleaner.remove_silencers!
ActiveRecord::Migrator.migrations_paths = 'spec/dummy/db/migrate'

#
# Load support files
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"
  config.use_transactional_fixtures = true
end
