SCHEME = Tests
DESTINATION = "name=iPhone Retina (4-inch 64-bit),OS=7.0"

clean:
	xcodebuild clean

test:
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination $(DESTINATION) \
		OBJROOT=. \

test-with-coverage:
	xcodebuild test \
		-scheme $(SCHEME) \
		-destination $(DESTINATION) \
		OBJROOT=. \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES

send-coverage:
	coveralls \
		--exclude Demo \
		--exclude Tests \
		--verbose
