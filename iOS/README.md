# SafeYou-iOS

* Introduction:
	Native iOS application written in Objective C and Swift
    Used Foundation Framework and CocoaTouch Frameworks.
	Also used third party libraries and frameworks which dependencies are configured with CocoaPods.
	Application Deployment targets are iOS versions above 13.0

 * Requirements:
	MacOS versions above 13.0
	Xcode versions above 13.0
	CocoaPods installed on Mac

 * Installation:
	Download Project sources from repository
	Do pod install (or pod update) in project root folder
	Open <project_name>.xcworkspace file with Xcode
	Select iOS device or simulator and run the application

 * Configuration:
	Setup developer and/or distribution Certificates from Apple Developer Account
	Optional: to enable Lokalise over-the-air translations, copy SafeYou/Config/Secrets.example.xcconfig to SafeYou/Config/Secrets.xcconfig and set your own values. Without it, the app uses the strings bundled in Resources/Translations

 * Troubleshooting:
	Make sure that API URLs and SocketIO URLs (defined in Settings.m depending on the build configuration and user selected Country) are available

 * Maintainers:
	Garnik Simonyan
	email: garnik.simonyan@gmail.com
	phone: +37455103132
	bitbucket: bitgarnik 

