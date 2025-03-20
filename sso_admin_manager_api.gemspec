$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sso_admin_manager_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sso_admin_manager_api"
  s.version     = SsoAdminManagerApi::VERSION
  s.authors     = ["Thomas Hoen"]
  s.email       = ["tom@givecorps.com"]
  s.homepage    = ""
  s.summary     = "Allows the NFG SSO server to poll for users and authenticate them."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 7.2"
  s.add_dependency "responders"
  s.add_dependency "active_model_serializers"
  s.add_dependency "jwt"

  s.add_development_dependency "rspec-rails", "~> 6.1"
  s.add_development_dependency "rspec_junit_formatter"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-byebug"
end
