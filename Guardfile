# Guardfile
# vim:filetype=ruby

require 'guard/plugin'

SCHEME = 'Tests'
SUFFIX = '2>&1 | xcpretty -c'

module ::Guard
  class InlineGuard < ::Guard::Plugin

    def command
      "xctest-runner -scheme #{SCHEME} #{@only} #{SUFFIX}"
    end

    def run_all
      system(command)
    end

    def run_on_changes(paths)
      test_class = File.basename(paths[0], '.*')
      test_case = nil
      if !test_class.empty?
        @only = "-test #{test_class}" + (test_case ? "/#{test_case}" : '')
      end
      system(command)
    end
  end
end

guard :inline_guard do
  watch /.*\.[mh]$/
end
