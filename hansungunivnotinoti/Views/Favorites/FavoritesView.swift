//
//  FavoriteView.swift
//  hansunguivnotinoti
//
//  Created by Finny Jakey on 2023/06/22.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesVM: FavoritesViewModel

    var body: some View {
        NavigationView {
            List {
                if favoritesVM.favorites.isEmpty {
                    HStack(alignment: .center, spacing: 15) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("공지사항에서 새로운 즐겨찾기를 등록해보세요!")
                    }
                } else {
                    ForEach(favoritesVM.favorites, id: \.id) { favorite in
                        NavigationLink(destination: WebViewRepresentable(url: favorite.link ?? "")) {
                            VStack(alignment: .leading, spacing: 5.0) {
                                Text(favorite.title ?? "")
                                    .lineLimit(2)
                                HStack {
                                    Text(favorite.category ?? "")
                                        .lineLimit(1)
                                    Text("|")
                                    Text(favorite.pubDate?.split(separator: " ")[0] ?? "")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                favoritesVM.deleteFavorite(favorite: favorite)
                            } label: {
                                Image(systemName: "star.slash")
                            }
                            .environment(\.symbolVariants, .none)
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("즐겨찾기")
        }
        .onAppear {
            favoritesVM.getAllFavorites()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(favoritesVM: FavoritesViewModel())
    }
}
