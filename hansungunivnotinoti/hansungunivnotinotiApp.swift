//
//  hansungunivnotinotiApp.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/27.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

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
