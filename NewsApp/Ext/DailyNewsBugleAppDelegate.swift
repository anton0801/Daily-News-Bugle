import SwiftUI
import AppTrackingTransparency
import AppsFlyerLib
import Combine
import OneSignal
import AdSupport

class DailyNewsBugleAppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate {
    
    private var appslfyerKey = "7GQDungFMZvZu3MrGjeCpY"
    private var appleIdApp = "6737353755"
    private var onesignalKey = "299ab750-0a47-4afd-a49b-9c86c993a45a"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = appslfyerKey
        AppsFlyerLib.shared().appleAppID = appleIdApp
        AppsFlyerLib.shared().isDebug = false
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        AppsFlyerLib.shared().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(bdsajhbdasj),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId(onesignalKey)
        promptPushAccept()
        openNotificationHandler()
        return true
    }
    
    private func promptPushAccept() {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            DispatchQueue.global().asyncAfter(deadline: .now() + 25) {
                if let playerId = OneSignal.getDeviceState()?.userId {
                    Common.sendIdPlayer(playerId: playerId)
                }
            }
        })
    }
    
    private func openNotificationHandler() {
        OneSignal.setNotificationOpenedHandler { fnjsakndjaksndkja in
            let notfDataSrc = fnjsakndjaksndkja.notification.jsonRepresentation()
            guard let notifDataEnc = try? JSONSerialization.data(withJSONObject: notfDataSrc),
                  let notifData = String(data: notifDataEnc, encoding: .utf8) else { return }
            Common.informAboutOpenPush(data: notifData)
        }
    }
    
    func onConversionDataSuccess(_ conversionData: [AnyHashable: Any]) {
        NotificationCenter.default.post(name: Notification.Name("conversion_loaded"), object: nil, userInfo: ["data": conversionData])
    }
    
    @objc private func bdsajhbdasj() {
        AppsFlyerLib.shared().start()
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                UserDefaults.standard.set(ASIdentifierManager.shared().advertisingIdentifier.uuidString, forKey: "idfa_user_app")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        NotificationCenter.default.post(name: Notification.Name("conversion_loaded"), object: nil, userInfo: ["data": [:]])
    }
    
}


struct Common {
    
    static func sendIdPlayer(playerId: String) {
        let dnsjabdjhad = UserDefaults.standard.bool(forKey: "sent_player_id")
        if !dnsjabdjhad {
            if let dbshjadbhjad = UserDefaults.standard.string(forKey: "client_id") {
                let ndjsandksandk = "https://dailynew.space/technicalPostback/v1.0/postClientParams/\(dbshjadbhjad)?onesignal_player_id=\(playerId)"
                guard let sdbahbdsjad = URL(string: ndjsandksandk) else { return }
                var dsakndasr = URLRequest(url: sdbahbdsjad)
                dsakndasr.httpMethod = "POST"
                URLSession.shared.dataTask(with: dsakndasr) { data, response, error in
                    guard data != nil, error == nil else { return }
                    UserDefaults.standard.setValue(true, forKey: "sent_player_id")
                }.resume()
            }
        }
    }
    
}

extension Common {
    
    static func informAboutOpenPush(data: String) {
        guard let encodedData = data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        if let id = UserDefaults.standard.string(forKey: "session_id"),
           let dnsahjbda = URL(string: "https://dailynew.space/technicalPostback/v1.0/postSessionParams/\(id)?push_data=\(encodedData)&from_push=true") {
            var bdshjabdas = URLRequest(url: dnsahjbda)
            bdshjabdas.httpMethod = "POST"
            URLSession.shared.dataTask(with: bdshjabdas) { data, response, error in
                guard data != nil, error == nil else { return }
            }.resume()
        }
    }
    
}
