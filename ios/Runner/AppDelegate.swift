import Flutter
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let options = FirebaseOptions(
      googleAppID: "1:538391182393:ios:8944fcbd8fe031dd44a1e8",
      gcmSenderID: "538391182393"
    )
    options.apiKey = "AIzaSyBmEEohZ6pFISXYHCWG8MX2JFuXij-gLOg"
    options.projectID = "cpy-c4d75"
    options.bundleID = "com.jsb.cpyApp"
    options.storageBucket = "cpy-c4d75.firebasestorage.app"

    FirebaseApp.configure(options: options)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}