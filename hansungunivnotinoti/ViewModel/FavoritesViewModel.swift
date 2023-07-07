//
//  FavoriteViewModel.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/23.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Favorite] = []
    
    let dataService = PersistenceController.shared
    
    init() {
        getAllFavorites()
    }

    func getAllFavorites() {
        favorites = dataService.read()
    }

    func createFavorite(id: String, title: String, link: String, pubDate: String, author: String, category: String, description_s: String) {
        dataService.create(id: id, title: title, link: link, pubDate: pubDate, author: author, category: category, description_s: description_s)
        getAllFavorites()
    }
    
    func deleteFavorite(favorite: Favorite) {
        dataService.delete(favorite)
        getAllFavorites()
    }
}
