//
//  XMLParser.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/22.
//

import Foundation

class NoticeXMLParserDelegate: NSObject, XMLParserDelegate {
    var currentItem: Notice?
    var items: [Notice] = []
    var currentElement: String = ""
    var currentTitle: String = ""
    var currentLink: String = ""
    var currentPubDate: String = ""
    var currentAuthor: String = ""
    var currentCategory: String = ""
    var currentDescription: String = ""
    
    // element의 시작 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentPubDate = ""
            currentAuthor = ""
            currentCategory = ""
            currentDescription = ""
        }
    }
    
    // element의 내용을 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "pubDate":
            currentPubDate += string
        case "author":
            currentAuthor += string
        case "category":
            currentCategory += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }
    
    // element의 종료 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = Notice(title: currentTitle, link: "https://www.hansung.ac.kr\(currentLink)?layout=unknown", pubDate: currentPubDate, author: currentAuthor, category: currentCategory, description: currentDescription)
                        
            items.append(item)
        }
        
        currentElement = ""
    }
}
