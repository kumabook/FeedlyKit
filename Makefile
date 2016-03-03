XCODEBUILD:=xctool

default: test

test:
	$(XCODEBUILD) -scheme FeedlyKit-iOS test -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-Mac test


#	$(XCODEBUILD) -sdk iphonesimulator -arch i386 -scheme FeedlyKit-iOS test

clean:
	$(XCODEBUILD) -scheme FeedlyKit-iOS clean -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-Mac clean

.PHONY: test clean default
