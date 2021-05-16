# SafeYou-iOS

* Introduction:
	Native iOS application written in Objective C used Foundation Framework and CocoaTouch Frameworks.
	Also used third party libraries and frameworks which dependencies are configured with CocoaPods.
	Application Deployment targets are iOS versions above 11.0

 * Requirements:
	MacOS versions above 10.14
	Xcode versions above 11.0
	CocoaPods installed on Mac

 * Installation:
	Download Project sources from repository
	Do pod install (or pod update) in project root folder
	Open <project_name>.xcworkspace file with Xcode
	Select iOS device or simulator and run the application

 * Configuration:
	Setup developer and/or distribution Certificates from Apple Developer Account
	Setup Push Notifications certificates in Apple Developer Account
	Setup Firebase in Firebase console (Which will be associated with current owner)

 * Troubleshooting:
	Make sure that API URLs (defined in Constants.h file) and SocketIO URLs (Defined in Settings.m depending user selected Country) are available

 * Maintainers:
	Garnik Simonyan
	email: garnik.simonyan@gmail.com
	phone: +37455103132
	bitbucket: bitgarnik 

