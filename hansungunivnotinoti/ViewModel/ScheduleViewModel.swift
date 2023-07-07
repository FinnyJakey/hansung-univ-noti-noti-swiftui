//
//  ScheduleViewModel.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/07/06.
//

import Foundation
import SwiftSoup

class ScheduleViewModel: ObservableObject {
    @Published var state: LoadingState = .idle
    @Published var currentYear = ""
    @Published var schedule: [[Schedule]] = []
    
    func fetchData() async {
        DispatchQueue.main.async {
            self.state = .loading
        }
        
        guard let url = URL(string: "https://www.hansung.ac.kr/schdulmanage/eduinfo/7/yearSchdul.do") else {
            return
        }
        
        guard let html = try? String(contentsOf: url, encoding: .utf8) else {
            return
        }
        
        guard let doc: Document = try? SwiftSoup.parse(html) else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentYear = try! doc.select("body > div.wrap > div.search").attr("title").replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        }
                
        let monthlyDataList = try! doc.getElementsByClass("yearSchdulWrap")
        
        for monthlyData in monthlyDataList {
            let dailyDataList = try! monthlyData.getElementsByTag("dl")
            
            let dateList = dailyDataList.map { element in
                try! element.getElementsByTag("dt").text()
            }
            
            let contentList = dailyDataList.map { element in
                try! element.getElementsByTag("dd").text()
            }
            
            let scheduleList: [Schedule] = dailyDataList.enumerated().map { index, element in
                Schedule(date: dateList[index], content: contentList[index])
            }

            DispatchQueue.main.async {
                self.schedule.append(scheduleList)
            }
        }
        
        DispatchQueue.main.async {
            self.state = .loaded
        }
    }
}
