SCHEME = Tests
DESTINATION = "name=iPhone Retina (4-inch 64-bit),OS=7.0"
OBJDIR = "tmp"

clean:
	xcodebuild clean

test:
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination $(DESTINATION)

test-with-coverage:
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination $(DESTINATION) \
		OBJROOT=$(OBJDIR) \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES

coverstory:
	make test-with-coverage
	/Applications/CoverStory.app/Contents/MacOS/CoverStory $(OBJDIR) &

coveralls:
	coveralls \
		--exclude Demo \
		--exclude Tests \
		--verbose
