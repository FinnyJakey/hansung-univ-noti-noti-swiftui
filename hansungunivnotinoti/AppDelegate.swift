//
//  AppDelegate.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/27.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @Published var tappedNotification: Bool = false
    @Published var webViewLink: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: "DeviceToken")
        print("AppDelegate - Firebase registration token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 푸시메세지가 앱이 켜져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo

        print("willPresent: userInfo: ", userInfo)

        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        completionHandler([.banner, .sound, .badge])
    }

    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        print("didReceive: userInfo: ", userInfo)
        
        let application = UIApplication.shared
        
        // Foreground
        if application.applicationState == .active {
            webViewLink = userInfo["link"] as! String
            tappedNotification.toggle()
        }
        
        // Background
        if application.applicationState == .inactive {
            webViewLink = userInfo["link"] as! String
            tappedNotification.toggle()
        }
        
        // Terminated
        if application.applicationState == .background {
            webViewLink = userInfo["link"] as! String
            tappedNotification.toggle()
        }
        
        print(userInfo["link"] ?? "????")

        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }

        completionHandler()
    }
}
