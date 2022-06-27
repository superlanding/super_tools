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
  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2", "< 3"
  spec.add_development_dependency "rake", ">= 12.2"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "shoulda-context"
  spec.add_development_dependency "warning"
  spec.add_development_dependency "sqlite3", "1.4.4"

  spec.add_dependency "rails", "> 6", "< 7"
  spec.add_dependency "nokogiri", ">= 1.6"
  spec.add_dependency "fast_excel"
  spec.add_dependency "roo"
  spec.add_dependency "roo-xls", "1.2.0"
  spec.add_dependency "spreadsheet"
  spec.add_dependency "virtus", "~> 1.0.5"
  spec.add_dependency "forwardable"
  spec.add_dependency "warehouse_items", "~> 0.3.0"
  spec.add_dependency "searchkick"
  # 升級會有一些問題
  spec.add_dependency "reform", "2.6.2"
  spec.add_dependency "reform-rails", "0.2.3"
  spec.add_dependency "dry-types", "0.15.0"
  spec.add_dependency "dry-logic", "0.5.0"
  # spec.add_dependency "disposable", "0.4.4"
end
