XCODEBUILD:=xctool

default: test example

test:
#	$(XCODEBUILD) -scheme FeedlyKit-iOS test -sdk iphonesimulator # wait for xctool update
	$(XCODEBUILD) -scheme FeedlyKit-Mac test

example:
	pod setup
	pod install --project-directory=Example
	$(XCODEBUILD) -scheme FeedlyKitExample -sdk iphonesimulator -workspace Example/FeedlyKitExample.xcworkspace/

clean:
	$(XCODEBUILD) -scheme FeedlyKit-iOS clean -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-Mac clean

.PHONY: test example clean default
