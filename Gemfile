source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in super_tools.gemspec
gemspec

require "warning"

Gem.path.each do |path|
  # https://github.com/superlanding/landing/issues/1640#issuecomment-1158440966
  Warning.ignore(/warning: method redefined; discarding old workbook/, path)
end
