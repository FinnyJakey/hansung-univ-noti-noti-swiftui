//
//  ContentView.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/27.
//

import SwiftUI

struct ContentView: View {
    @State private var userColorScheme = UserDefaults.standard.string(forKey: "Theme") ?? "Automatic"
    @State private var userColor: Color = .indigo.opacity(0.7)
    @StateObject var favoritesVM: FavoritesViewModel = FavoritesViewModel()
    
    @EnvironmentObject private var appDelegate: AppDelegate

    var body: some View {
        NavigationStack {
            TabView {
                NoticeView(favoritesVM: favoritesVM)
                    .tabItem {
                        Label("공지사항", systemImage: "note.text")
                        Text("공지사항")
                    }
                FavoritesView(favoritesVM: favoritesVM)
                    .tabItem {
                        Label("즐겨찾기", systemImage: "star")
                            .environment(\.symbolVariants, .none)
                    }
                ScheduleView()
                    .tabItem {
                        Label("학사일정", systemImage: "calendar")
                    }
                BusView()
                    .tabItem {
                        Label("버스", systemImage: "bus")
                    }
                SettingView(userColorScheme: $userColorScheme, userColor: $userColor)
                    .tabItem {
                        Label("설정", systemImage: "gearshape")
                            .environment(\.symbolVariants, .none)
                    }
            }
            
            .navigationDestination(isPresented: $appDelegate.tappedNotification) {
                WebViewRepresentable(url: appDelegate.webViewLink)
            }
        }
        .tint(userColor)
        .preferredColorScheme(getColorScheme(userColorScheme))
        .onAppear {
            userColor = getColor()
        }
    }
    
    private func getColorScheme(_ userColorScheme: String) -> Optional<ColorScheme> {
        var result: Optional<ColorScheme>
        
        switch userColorScheme {
        case "Automatic":
            result = .none
        case "Dark":
            result = .dark
        case "Light":
            result = .light
        default:
            result = .none
        }
        
        return result
    }
    
    private func getColor() -> Color {
        guard let colorComponents = UserDefaults.standard.object(forKey: "Tint") as? [CGFloat] else {
            return Color.indigo.opacity(0.7)
        }
        
        let color = Color(.sRGB, red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], opacity: colorComponents[3])
        
        return color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
