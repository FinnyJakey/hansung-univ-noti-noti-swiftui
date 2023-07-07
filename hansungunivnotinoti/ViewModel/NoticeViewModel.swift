//
//  NoticeViewModel.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/22.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case failed
}

class NoticeViewModel: ObservableObject {
    @Published var state: LoadingState = .idle
    @Published var noticeItems: [Notice] = []
    @Published var error: String = ""
    
    var page: Int = 0
    
    func fetchData() async {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        guard let url = URL(string: "https://hansung.ac.kr/bbs/hansung/143/rssList.do?row=50&page=\(page.increase())") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            parseData(data)
        } catch {
            DispatchQueue.main.async {
                self.state = .failed
                self.error = error.localizedDescription
            }
            return
            
        }
        
        DispatchQueue.main.async {
            self.state = .loaded
        }
    }
    
    func parseData(_ data: Data) {
        let parser = XMLParser(data: data)
        let delegate = NoticeXMLParserDelegate()
        parser.delegate = delegate
        
        if parser.parse() {
            DispatchQueue.main.async {
                self.noticeItems += delegate.items
            }
        } else {
            DispatchQueue.main.async {
                self.state = .failed
                self.error = "XML parse failed"
            }
        }
    }
    
    func clearAll() {
        noticeItems.removeAll()
        page = 0
    }
}

extension Int {
    mutating func increase() -> Int {
        self += 1
        return self
    }
}
