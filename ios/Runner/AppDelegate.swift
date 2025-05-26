import Flutter
import UIKit

import GoogleMaps

import FBSDKCoreKit
import FBSDKCoreKit_Basics
import FBAudienceNetwork

//import TikTokConfig
import TikTokBusinessSDK

import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
// FlutterPlugin
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Facebook Analytics
        Settings.shared.loggingBehaviors = [.appEvents]
        AppEvents.shared.activateApp()
        
        // TikTok
        let config = TikTokConfig.init(appId: "6444398869", tiktokAppId: "7400222884121427976")
        // config?.enableDebugMode()
        TikTokBusiness.initializeSdk(config)
        
        // Google Map API key
        GMSServices.provideAPIKey("AIzaSyD1OwkCi9RRsjkoAB2v1gSZTRdoa_tjoc4")
        if let url = launchOptions?[.url] as? URL {
            let defaults = UserDefaults.standard
            defaults.set(
                url.absoluteString,
                forKey: DefaultsKeys.keyReferrer
            )
        }
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.coffee2u.aroma", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
            self?.handle2(call, result: result)
        }

        // Retrieve the link from parameters
        if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
        // We have a link, propagate it to your Flutter app or not
        AppLinks.shared.handleLink(url: url)
            return true // Returning true will stop the propagation to other packages
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(
        _ application: UIApplication, 
        open url: URL, 
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if let scheme = url.scheme {
             if url.scheme == "com.coffee2u.aroma" {
                 let data = url.absoluteString.replacingOccurrences(of: "com.coffee2u.aroma://", with: "https://")
                 let defaults = UserDefaults.standard
                 defaults.set(
                    data,
                    forKey: DefaultsKeys.keyReferrer
                 )
             }else {
                 if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                     let queryItems = components.queryItems {
                     let defaults = UserDefaults.standard
                     defaults.set(
                         queryItems,
                         forKey: DefaultsKeys.keyReferrer
                     )
                 }
             }
            return super.application(application, open: url, options: options)
        }
        return false
    }

    public func handle2(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "app_install_referrer":
            let defaults = UserDefaults.standard
            if let stringOne = defaults.string(
                forKey: DefaultsKeys.keyReferrer
            ) {
                result(stringOne)
            }else {
                result("")
            }
            break
        case "clearUserData":
            handleClearUserData(call, result: result)
            break
        case "setUserData":
            handleSetUserData(call, result: result)
            break
        case "clearUserID":
            handleClearUserID(call, result: result)
            break
        case "flush":
            handleFlush(call, result: result)
            break
        case "getApplicationId":
            handleGetApplicationId(call, result: result)
            break
        case "logEvent":
            handleLogEvent(call, result: result)
            break
        case "logPushNotificationOpen":
            handlePushNotificationOpen(call, result: result)
            break
        case "setUserID":
            handleSetUserId(call, result: result)
            break
        case "setAutoLogAppEventsEnabled":
            handleSetAutoLogAppEventsEnabled(call, result: result)
            break
        case "setDataProcessingOptions":
            handleSetDataProcessingOptions(call, result: result)
            break
        case "logPurchase":
            handlePurchased(call, result: result)
            break
        case "getAnonymousId":
            handleHandleGetAnonymousId(call, result: result)
            break
        case "setAdvertiserTracking":
            handleSetAdvertiserTracking(call, result: result)
            break
        case "tiktokLogEvent":
            handleTikTokLogEvent(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleClearUserData(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.shared.clearUserData()
        result(nil)
    }

    private func handleSetUserData(_ call: FlutterMethodCall, result: @escaping FlutterResult) {        
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()

        AppEvents.shared.setUserData(arguments["email"] as? String, forType: FBSDKAppEventUserDataType.email)
        AppEvents.shared.setUserData(arguments["firstName"] as? String, forType: FBSDKAppEventUserDataType.firstName)
        AppEvents.shared.setUserData(arguments["lastName"] as? String, forType: FBSDKAppEventUserDataType.lastName)
        AppEvents.shared.setUserData(arguments["phone"] as? String, forType: FBSDKAppEventUserDataType.phone)
        AppEvents.shared.setUserData(arguments["dateOfBirth"] as? String, forType: FBSDKAppEventUserDataType.dateOfBirth)
        AppEvents.shared.setUserData(arguments["gender"] as? String, forType: FBSDKAppEventUserDataType.gender)
        AppEvents.shared.setUserData(arguments["city"] as? String, forType: FBSDKAppEventUserDataType.city)
        AppEvents.shared.setUserData(arguments["state"] as? String, forType: FBSDKAppEventUserDataType.state)
        AppEvents.shared.setUserData(arguments["zip"] as? String, forType: FBSDKAppEventUserDataType.zip)
        AppEvents.shared.setUserData(arguments["country"] as? String, forType: FBSDKAppEventUserDataType.country)

        result(nil)
    }

    private func handleClearUserID(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.shared.userID = nil
        result(nil)
    }

    private func handleFlush(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        AppEvents.shared.flush()
        result(nil)
    }

    private func handleGetApplicationId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(Settings.shared.appID)
    }

    private func handleHandleGetAnonymousId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(AppEvents.shared.anonymousID)
    }

    private func handleTikTokLogEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let eventName = arguments["name"] as! String
        let parameters = arguments["parameters"] as? [AppEvents.ParameterName: Any] ?? [AppEvents.ParameterName: Any]()
        
        if arguments["_valueToSum"] != nil && !(arguments["_valueToSum"] is NSNull) {
            let valueToDouble = arguments["_valueToSum"] as! Double
//            print("parameters: 1")
            // AppEvents.shared.logEvent(AppEvents.Name(eventName), valueToSum: valueToDouble, parameters: parameters)
            TikTokBusiness.trackEvent(eventName, withProperties: parameters)
        } else {
            // let properties = NSMutableDictionary()
            // properties.setValue("value1", forKey:"key1") 
            TikTokBusiness.trackEvent(eventName, withProperties: parameters)
        }

        result(nil)
    }

    private func handleLogEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let eventName = arguments["name"] as! String
        let parameters = arguments["parameters"] as? [AppEvents.ParameterName: Any] ?? [AppEvents.ParameterName: Any]()
        
        if arguments["_valueToSum"] != nil && !(arguments["_valueToSum"] is NSNull) {
            let valueToDouble = arguments["_valueToSum"] as! Double
//            print("parameters: 1")
            AppEvents.shared.logEvent(AppEvents.Name(eventName), valueToSum: valueToDouble, parameters: parameters)
        } else {
//            Settings.shared.isAutoLogAppEventsEnabled = true
//            Settings.shared.isSKAdNetworkReportEnabled = true
//            FBAdSettings.setAdvertiserTrackingEnabled(true)
//            Settings.shared.isAdvertiserTrackingEnabled = true
            AppEvents.shared.logEvent(
                AppEvents.Name(eventName),
                parameters: parameters
            )
        }

        result(nil)
    }

    private func handlePushNotificationOpen(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let payload = arguments["payload"] as? [String: Any]
        if let action = arguments["action"] as? String {
            AppEvents.shared.logPushNotificationOpen(payload: payload!, action: action)
        } else {
            AppEvents.shared.logPushNotificationOpen(payload: payload!)
        }
        result(nil)
    }

    private func handleSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let id = call.arguments as! String
        AppEvents.shared.userID = id
        result(nil)
    }

    private func handleSetAutoLogAppEventsEnabled(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let enabled = call.arguments as! Bool
        Settings.shared.isAutoLogAppEventsEnabled = enabled
        result(nil)
    }

    private func handleSetDataProcessingOptions(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let modes = arguments["options"] as? [String] ?? []
        let state = arguments["state"] as? Int32 ?? 0
        let country = arguments["country"] as? Int32 ?? 0

        Settings.shared.setDataProcessingOptions(modes, country: country, state: state)

        result(nil)
    }

    private func handlePurchased(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let amount = arguments["amount"] as! Double
        let currency = arguments["currency"] as! String
        let parameters = arguments["parameters"] as? [AppEvents.ParameterName: Any] ?? [AppEvents.ParameterName: Any]()
        AppEvents.shared.logPurchase(amount: amount, currency: currency, parameters: parameters)

        result(nil)
    }

    private func handleSetAdvertiserTracking(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let enabled = arguments["enabled"] as! Bool
        let collectId = arguments["collectId"] as! Bool
        FBAdSettings.setAdvertiserTrackingEnabled(enabled)
        Settings.shared.isSKAdNetworkReportEnabled = enabled
        Settings.shared.isAdvertiserTrackingEnabled = enabled
        Settings.shared.isAdvertiserIDCollectionEnabled = collectId
        result(nil)
    }
}

struct DefaultsKeys {
    static let keyReferrer = "referrer_url"
}
