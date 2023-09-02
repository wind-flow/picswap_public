import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    //UITextField 개체 생성
  private var textField = UITextField()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    //함수 추가
    makeSecureYourScreen() 

        //MethodChannel생성
    let controller : FlutterViewController = self.window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "secureShotChannel", binaryMessenger: controller.binaryMessenger)
    securityChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "secureIOS" {
                self.textField.isSecureTextEntry = true
            } else if call.method == "unSecureIOS" {
                self.textField.isSecureTextEntry = false
            }
    })
    // sleep(2)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    //UITextField 화면에 삽입
  private func makeSecureYourScreen() {
    if (!self.window.subviews.contains(textField)) {
        self.window.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.window.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.window.centerXAnchor).isActive = true
        self.window.layer.superlayer?.addSublayer(textField.layer)
        textField.layer.sublayers?.first?.addSublayer(self.window.layer)
    }
  }
}
