//
//  SettingView.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/22.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.openURL) private var openURL
    @State private var selectedColorScheme: ColorSchemeOption = .Automatic
    @Binding var userColorScheme: String
    @Binding var userColor: Color
    @State private var deviceToken: String = ""
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        NavigationView {
            List {                
                Section("테마") {
                    Picker("다크 모드 설정", selection: $selectedColorScheme) {
                        ForEach(ColorSchemeOption.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .onChange(of: selectedColorScheme) { newValue in
                        UserDefaults.standard.set(newValue.rawValue, forKey: "Theme")
                        userColorScheme = newValue.rawValue
                    }
                    
                    ColorPicker("글자 / 아이콘", selection: $userColor)
                        .onChange(of: userColor) { newValue in
                            userColor = newValue
                            saveColor(color: newValue)
                        }
                }
                
                Section {
                    Link(destination: URL(string: "https://open.kakao.com/o/sHE6ZUrf")!) {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("개발자에게 문의")
                            
                            Text("혹은 아샷추 사주기")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button {
                        pasteboard.string = deviceToken
                    } label: {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("디바이스 토큰 복사")
                                .foregroundColor(.primary)
                            
                            Text(deviceToken)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                } header: {
                    Text("도움말 및 지원")
                } footer: {
                    Link("개인정보 처리방침", destination: URL(string: "https://blog.naver.com/egel10c_/222916918892")!)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                switch UserDefaults.standard.string(forKey: "Theme") ?? "Automatic" {
                case "Automatic":
                    selectedColorScheme = .Automatic
                case "Dark":
                    selectedColorScheme = .Dark
                case "Light":
                    selectedColorScheme = .Light
                default:
                    selectedColorScheme = .Automatic
                }
                
                deviceToken = UserDefaults.standard.string(forKey: "DeviceToken") ?? "Unable to get Device Token"
            }
        .navigationTitle("설정")
        }
    }
    
    private func saveColor(color: Color) {
        let color = UIColor(color).cgColor
        
        if let components = color.components {
            UserDefaults.standard.set(components, forKey: "Tint")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(userColorScheme: .constant("Dark"), userColor: .constant(.indigo.opacity(0.7)))
    }
}

enum ColorSchemeOption: String, CaseIterable {
    case Automatic = "Automatic"
    case Dark = "Dark"
    case Light = "Light"
}
