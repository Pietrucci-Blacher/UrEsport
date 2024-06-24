import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var mapsApiKey = ProcessInfo.processInfo.environment["MAPS_API_KEY"] ?? findMapApiKeyFromDartDefines("MAPS_API_KEY") ?? ""
    if (mapsApiKey.isEmpty) {
       mapsApiKey = "YOUR_API_KEY"
    }
    GMSServices.provideAPIKey(mapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func findMapApiKeyFromDartDefines(_ defineKey: String) -> String? {
            if (Bundle.main.infoDictionary!["DART_DEFINES"] == nil) {
                return nil
            }

            let dartDefinesString = Bundle.main.infoDictionary!["DART_DEFINES"] as! String
            let base64EncodedDartDefines = dartDefinesString.components(separatedBy: ",")
            for base64EncodedDartDefine in base64EncodedDartDefines {
                let decoded = String(data: Data(base64Encoded: base64EncodedDartDefine)!, encoding: .utf8)!
                let values = decoded.components(separatedBy: "=")
                if (values[0] == defineKey && values.count == 2) {
                    return values[1]
                }
            }
            return nil
  }
}
