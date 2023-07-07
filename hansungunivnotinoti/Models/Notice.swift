//
//  Notice.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/22.
//

import Foundation

struct Notice: Identifiable, Equatable {
    let id: String
    let title: String
    let link: String
    let pubDate: String
    let author: String
    let category: String
    let description: String
    
    init(title: String, link: String, pubDate: String, author: String, category: String, description: String) {
        self.id = String(link.split(separator: "/")[5])
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.author = author
        self.category = category
        self.description = description
    }
}
