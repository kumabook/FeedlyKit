XCODEBUILD:=xcodebuild

default: test example

test:
#	$(XCODEBUILD) -scheme FeedlyKit-iOS test -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-macOS test

example:
	pod setup
	pod install --project-directory=Example
	$(XCODEBUILD) -scheme FeedlyKitExample -sdk iphonesimulator -workspace Example/FeedlyKitExample.xcworkspace/

clean:
	$(XCODEBUILD) -scheme FeedlyKit-iOS clean -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-macOS clean

.PHONY: test example clean default
