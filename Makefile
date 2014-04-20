PROJECT = TKRGuard.xcodeproj
SCHEME = Tests
SDK = iphonesimulator
OBJDIR = "tmp"

clean:
	xctool \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk $(SDK) \
		clean \
		$(SUFFIX)

test:
	xctool \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk $(SDK) \
		test \
		$(SUFFIX)

test-with-coverage:
	xctool \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk $(SDK) \
		OBJROOT=$(OBJDIR) \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES \
		test \
		$(SUFFIX)

coverstory:
	make test-with-coverage
	/Applications/CoverStory.app/Contents/MacOS/CoverStory $(OBJDIR) &

coveralls:
	coveralls \
		--exclude Demo \
		--exclude Tests \
		--verbose
