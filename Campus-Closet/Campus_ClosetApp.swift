//
//  Campus_ClosetApp.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/22/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}



@main
struct Campus_ClosetApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                ContentView()
            }
            else {
                LogInView()
            }
        }
        else {
            LogInView()
        }
    }
  }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}
