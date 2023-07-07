//
//  hansungunivnotinotiApp.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/27.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

// TODO: KeywordView -> deviceToken fix :)
// TODO: SettingView -> Privacy Policy
// TODO: ScheduleView

// TODO: 15.0 -> 16.0 :)
// TODO: delete available -> NoticeView / NoticeWebView :)
// TODO: delete addKeyword -> KeywordView (onAppear) :)

@main
struct hansungunivnotinotiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
        }
    }
}
