# Guardfile
# vim:filetype=ruby

require 'guard/plugin'

module ::Guard
  class InlineGuard < ::Guard::Plugin
    TEST_TARGET = 'Tests'

    def clean
      system('make clean')
    end

    def test(suffix='')
      system("make test #{suffix}")
    end

    def run_all
      clean
      test
    end

    def run_on_changes(paths)
      test_class = File.basename(paths[0], '.*')
      test_case = nil
      unless test_class.empty?
        test_case = (test_case ? "/#{test_case}" : '')
        only = "SUFFIX=\"-only #{TEST_TARGET}:#{test_class}#{test_case}\""  
        test(only)
      else
        test
      end
    end
  end
end

guard :inline_guard do
  watch /.*\.[mh]$/
end
