source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in super_tools.gemspec
gemspec

require "warning"

Gem.path.each do |path|
  # https://github.com/superlanding/landing/issues/1640#issuecomment-1158440966
  Warning.ignore(/roo\/xls\/excel.rb:51: warning: method redefined; discarding old workbook/, path)

  # https://github.com/superlanding/landing/issues/1640#issuecomment-1158443893
  Warning.ignore(/reform\/form\/active_model.rb:\d+: warning: `\*' interpreted as argument prefix/, path)

  # https://github.com/superlanding/landing/issues/1640#issuecomment-1158450552
  Warning.ignore(/reform\/form\/active_model\/result.rb:4: warning: method redefined; discarding old filter_for/, path)
  Warning.ignore(/reform\/result.rb:33: warning: previous definition of filter_for was here/, path)

  # https://github.com/superlanding/landing/issues/1640#issuecomment-1158456627
  Warning.ignore(/rails_test_unit_reporter_patch.rb:\d+: warning: method redefined; discarding old format_rerun_snippet/, path)
  Warning.ignore(/reporter.rb:\d+: warning: previous definition of format_rerun_snippet was here/, path)
end
