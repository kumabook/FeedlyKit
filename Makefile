XCODEBUILD:=xcodebuild

default: build spm_build test example

build:
	$(XCODEBUILD) -scheme FeedlyKit-iOS
	$(XCODEBUILD) -scheme FeedlyKit-macOS
	$(XCODEBUILD) -scheme FeedlyKit-tvOS
	$(XCODEBUILD) -scheme FeedlyKit-watchOS

spm_build:
	swift build

test:
	$(XCODEBUILD) -scheme FeedlyKit-macOS test

coverage:
	slather coverage --html --scheme FeedlyKit-macOS ./FeedlyKit.xcodeproj

example:
	pod setup
	pod install --project-directory=Example
	$(XCODEBUILD) -scheme FeedlyKitExample -sdk iphonesimulator -workspace Example/FeedlyKitExample.xcworkspace/

clean:
	$(XCODEBUILD) -scheme FeedlyKit-iOS clean -sdk iphonesimulator
	$(XCODEBUILD) -scheme FeedlyKit-macOS clean
	$(XCODEBUILD) -scheme FeedlyKit-tvOS clean
	$(XCODEBUILD) -scheme FeedlyKit-watchOS clean

doc:
	jazzy \
		--author Hiroki Kumamoto \
		--author_url https://kumabook.github.io \
		--github_url https://github.com/kumabook/FeedlyKit

lint:
	swiftlint

.PHONY: lint test example clean default
