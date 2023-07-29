//
//  NoticeView.swift
//  hansunguivnotinoti
//
//  Created by Finny Jakey on 2023/06/22.
//

import SwiftUI

struct NoticeView: View {
    @StateObject var noticeVM = NoticeViewModel()
    @ObservedObject var favoritesVM: FavoritesViewModel
    @State private var searchText: String = ""
    @State private var showingKeyword = false
    @State private var initFetched = false
    @State private var isSearching = false
    @State private var searchAlertSeen = false
    @State private var toast: Toast? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(noticeVM.noticeItems, id: \.id) { notice in
                    NavigationLink(destination: WebViewRepresentable(url: notice.link)) {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text(notice.title)
                                .lineLimit(2)
                            HStack {
                                Text(notice.category)
                                    .lineLimit(1)
                                Text("|")
                                Text(notice.pubDate.split(separator: " ")[0])
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                    .onAppear {
                        if isSearching {
                            return
                        }
                        
                        if notice == noticeVM.noticeItems[noticeVM.noticeItems.count - 10] {
                            Task {
                                await noticeVM.fetchData()
                            }
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        if isFavorite(notice.id) {
                            Button {
                                if let favorite = getSameFavorite(notice.id) {
                                    favoritesVM.deleteFavorite(favorite: favorite)
                                }
                            } label: {
                                Image(systemName: "star.slash")
                            }
                            .environment(\.symbolVariants, .none)
                            .tint(.red)
                        } else {
                            Button {
                                favoritesVM.createFavorite(id: notice.id, title: notice.title, link: notice.link, pubDate: notice.pubDate, author: notice.author, category: notice.category, description_s: notice.description)
                            } label: {
                                Image(systemName: "star")
                            }
                            .environment(\.symbolVariants, .none)
                            .tint(.yellow)
                        }
                    }
                }
                
                if noticeVM.state == .loading {
                    ProgressView().id(UUID())
                        .frame(maxWidth: .infinity)
                }
                
                if noticeVM.state == .failed {
                    HStack(alignment: .center) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                        Text(noticeVM.error)
                    }
                }
                
                if isSearching && noticeVM.noticeItems.isEmpty && noticeVM.state != .loading && noticeVM.state != .failed {
                    HStack(alignment: .center) {
                        Image(systemName: "x.circle")
                            .foregroundColor(.red)
                        Text("No search results found")
                    }
                }
            }
            .navigationTitle("공지사항")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingKeyword.toggle()
                    } label: {
                        Image(systemName: "bell")
                        
                    }
                    .sheet(isPresented: $showingKeyword) {
                        KeywordView()
                            .presentationDetents([.medium, .large])
                    }
                    
                }
            }
        }
        .onAppear {
            if !initFetched {
                Task {
                    await noticeVM.fetchData()
                }
                initFetched.toggle()
            }
        }
        .searchable(text: $searchText, prompt: "공지사항을 검색해보세요!")
        .onSubmit(of: .search) {
            if !searchAlertSeen {
                searchAlertSeen = true
                toast = Toast(style: .info, message: "검색 결과는 최신 200개의 공지사항에만 반영됩니다.")
            }
            isSearching = true
            noticeVM.clearAll()
            Task {
                await noticeVM.fetchData(200, searchText)
            }
        }
        .toastView(toast: $toast)
        .refreshable {
            isSearching = false
            noticeVM.clearAll()
            await noticeVM.fetchData()
        }
        
        
        
    }
    
    func isFavorite(_ id: String) -> Bool {
        for favorite in favoritesVM.favorites {
            if favorite.id == id {
                return true
            }
        }
        
        return false
    }
    
    func getSameFavorite(_ id: String) -> Favorite? {
        for favorite in favoritesVM.favorites {
            if favorite.id == id {
                return favorite
            }
        }
        
        return nil
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView(favoritesVM: FavoritesViewModel())
    }
}
