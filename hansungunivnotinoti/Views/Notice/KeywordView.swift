//
//  KeywordView.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/23.
//

import SwiftUI

struct KeywordView: View {
    @State private var keywordAlert = false
    @State private var keywordMaximumAlert = false
    @State private var keywordMinimumAlert = false
    @State private var keywordAlreadyAlert = false
    @State private var keywordContainsSpaceAlert = false

    @State private var keywordText = ""
    @State private var deviceToken: String = ""
    
    @StateObject var keywordVM = KeywordsViewModel()

    var body: some View {
        NavigationView {
            List {
                if deviceToken.contains("Unable") {
                    HStack(alignment: .center) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                        Text("Unable to get Device Token")
                    }
                } else {
                    if keywordVM.state == .loading {
                        ProgressView().id(UUID())
                            .frame(maxWidth: .infinity)
                    } else if keywordVM.keywords.isEmpty {
                        HStack(alignment: .center, spacing: 15) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("새로운 키워드를 등록하고 알림을 받아보세요!")
                        }
                    } else {
                        ForEach(keywordVM.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        keywordVM.deleteKeyword(deviceToken: deviceToken, keyword: keyword)
                                        
                                        keywordVM.state = .loading
                                        keywordVM.getAllKeywords(deviceToken: deviceToken)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .environment(\.symbolVariants, .none)
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("키워드 알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if keywordVM.keywords.count < 20 {
                            keywordAlert.toggle()
                        } else {
                            keywordMaximumAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .alert("아래에 키워드를 입력해주세요.", isPresented: $keywordAlert) {
                        TextField("수강신청", text: $keywordText)
                        Button("등록", action: submit)
                        Button("취소", role: .cancel) {
                            
                        }
                    }
                    .alert("키워드는 최대 20개까지 등록이 가능합니다!", isPresented: $keywordMaximumAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("키워드는 최소 2글자 이상 입력해주세요!", isPresented: $keywordMinimumAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("동일한 키워드는 등록할 수 없습니다!", isPresented: $keywordAlreadyAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                    .alert("키워드에 공백은 등록할 수 없습니다!", isPresented: $keywordContainsSpaceAlert) {
                        Button("확인", role: .cancel) {

                        }
                    }
                }
            }
            .refreshable {
                if deviceToken.contains("Unable") {
                    return
                }
                
                keywordVM.state = .loading
                keywordVM.getAllKeywords(deviceToken: deviceToken)
            }
            .onAppear {
                deviceToken = UserDefaults.standard.string(forKey: "DeviceToken") ?? "Unable to get Device Token"
                
                if deviceToken.contains("Unable") {
                    return
                }

                keywordVM.state = .loading
                keywordVM.getAllKeywords(deviceToken: deviceToken)
            }
        }
    }
    
    func submit() {
        if keywordText.count < 2 {
            keywordMinimumAlert.toggle()
            keywordText = ""
            return
        }
        
        if keywordText.contains(" ") {
            keywordContainsSpaceAlert.toggle()
            keywordText = ""
            return
        }
        
        if keywordVM.keywords.contains(keywordText.lowercased()) {
            keywordAlreadyAlert.toggle()
            keywordText = ""
            return
        }
        
        keywordVM.addNewKeyword(deviceToken: deviceToken, keyword: keywordText.lowercased())
        
        keywordVM.state = .loading
        keywordVM.getAllKeywords(deviceToken: deviceToken)
        
        keywordText = ""
    }
}

struct KeywordView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordView()
    }
}
