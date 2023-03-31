import CoreLocation
import Flutter
import UIKit

public class FlutterGpsPlugin: NSObject, FlutterPlugin {
    var sysLocationManger: CLLocationManager?
    var locationResult: FlutterResult?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_gps", binaryMessenger: registrar.messenger())
        let instance = FlutterGpsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "gps":
            locationResult = result
            loaction()
        default:
            break
        }
    }

    private func loaction() {
        var lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = .leastNormalMagnitude
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        sysLocationManger = lm
    }
}

extension FlutterGpsPlugin: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lo = locations.last {
            sysLocationManger?.stopUpdatingLocation()
            sysLocationManger = nil
            let dict: Dictionary<String, Any> = ["code": "00000",
                                                 "message": "定位成功",
                                                 "latitude": lo.coordinate.latitude,
                                                 "longitude": lo.coordinate.longitude]
            locationResult?(dict)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        sysLocationManger?.stopUpdatingLocation()
        sysLocationManger = nil
        let dict: Dictionary<String, Any> = ["code": "A0001",
                                             "message": error.localizedDescription,
        ]
        locationResult?(dict)
    }
}
