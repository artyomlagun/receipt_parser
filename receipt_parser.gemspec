$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "receipt_parser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "receipt_parser"
  s.version     = ReceiptParser::VERSION
  s.authors     = ["Artyom Lagun"]
  s.email       = ["support@itexus.com"]
  s.homepage    = "http://itexus.com"
  s.summary     = "Receipts parsing API"
  s.description = "Rails engine for adding API endpoints for receipts parsing and validation"
  s.license     = "COMMERCIAL"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
  s.add_dependency "faraday"
end
