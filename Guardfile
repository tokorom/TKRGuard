# Guardfile

require 'guard/plugin'

module ::Guard
  class InlineGuard < ::Guard::Plugin
    SCHEME = 'Tests'
    DESTINATION = 'platform=iOS Simulator,name=iPhone Retina (3.5-inch),OS=7.0'
    SUFFIX = "| xcpretty -c"
    COMMAND = "xcodebuild test -scheme #{SCHEME} -destination '#{DESTINATION}' #{SUFFIX}"
    
    def run_all
      system(COMMAND)
    end

    def run_on_changes(paths)
      run_all
    end
  end
end

guard :inline_guard do
  watch /.*\.[mh]$/
end
