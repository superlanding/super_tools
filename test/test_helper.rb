$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "warning_ignore"
require "minitest/autorun"
require "super_tools"
require "shoulda-context"

# HELPERS
require "helpers/build_orders_helper"
require "helpers/db_helper"
