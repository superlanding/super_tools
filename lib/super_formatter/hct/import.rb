require 'super_formatter/import'
require 'super_formatter/hct/head'
require 'super_formatter/hct/row'
module SuperFormatter
  module Hct
    class Import < ::SuperFormatter::Import

      callable do
        build_rows!(Head, Row)
      end
    end
  end
end
