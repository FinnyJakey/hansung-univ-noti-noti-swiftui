//
//  BusViewModel.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/25.
//

import Foundation

class BusViewModel: ObservableObject {
    private let serviceKey: String = "WukqGY1taHLYXMlrEn0dF2hq09uhKT5eYYbajqu%2BlF7Rg9Sy4zu6OXXVWvnFnGl17wxpTRO3BPZ8qlePMTxYyg%3D%3D"
    // busRouteId = 107900003
    // busRouteId = 100900010
    
    @Published var state: LoadingState = .idle
    @Published var error: String = ""

    @Published var seongBukItems: [Bus] = []
    @Published var jongNoItems: [Bus] = []
    
    func fetchData(_ busRouteId: String) async {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        guard let url = URL(string: "http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRouteAll?serviceKey=\(serviceKey)&busRouteId=\(busRouteId)") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            parseData(busRouteId, data)
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
    
    func parseData(_ busRouteId: String, _ data: Data) {
        let parser = XMLParser(data: data)
        let delegate = BusXMLParserDelegate()
        parser.delegate = delegate
        
        if parser.parse() {
            DispatchQueue.main.async {
                if busRouteId == "107900003" {
                    self.seongBukItems = delegate.items
                } else {
                    self.jongNoItems = delegate.items
                }
            }
        }
    }
    
    func clearSeongBukItems() {
        seongBukItems.removeAll()
    }
    
    func clearJongNoItems() {
        jongNoItems.removeAll()
    }
}
