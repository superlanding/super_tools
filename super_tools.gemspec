
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "super_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "super_tools"
  spec.version       = SuperTools::VERSION
  spec.authors       = ["eddie"]
  spec.email         = ["eddie.li.624@gmail.com"]

  spec.summary       = %q{Rails 開發環境常用工具 Forms/Process/Spreadsheet}
  spec.description   = %q{Rails 開發環境常用工具 Forms/Process/Spreadsheet}
  spec.homepage      = "https://github.com/superlanding/super_tools"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "shoulda-context"


  spec.add_dependency "rails", ">= 4"
  # spec.add_dependency "i18n", "< 1"
  # spec.add_dependency "actionview", '>= 4', '<= 6'
  # spec.add_dependency 'activerecord', '>= 4', '<= 6'
  # spec.add_dependency "activemodel", '>= 4', '<= 6'
  # spec.add_dependency "activesupport", '>= 4', '<= 6'
  # spec.add_dependency "activeview"
  spec.add_dependency "nokogiri", ">= 1.6", "<= 1.9.1"
  spec.add_dependency "fast_excel"
  spec.add_dependency "roo"
  spec.add_dependency "roo-xls"
  spec.add_dependency "spreadsheet"
  spec.add_dependency "iconv"
  spec.add_dependency "virtus", '~> 1.0.5'
  spec.add_dependency "reform-rails"
  spec.add_dependency "reform", '~> 2.2.4'
  spec.add_dependency "dry-types", '~> 0.13.2'
  spec.add_dependency 'dry-logic', '~> 0.4.2'
  spec.add_dependency 'forwardable'
  spec.add_dependency 'warehouse_items', '~> 0.3.0'
  spec.add_dependency 'searchkick'
end
