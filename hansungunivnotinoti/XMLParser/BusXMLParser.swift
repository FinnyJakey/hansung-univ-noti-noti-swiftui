//
//  BusXMLParser.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/25.
//

import Foundation

class BusXMLParserDelegate: NSObject, XMLParserDelegate {
    var currentItem: Bus?
    var items: [Bus] = []
    var currentElement: String = ""
    var currentStId: String = ""
    var currentArrmsg1: String = ""
    var currentStNm: String = ""
    var currentExps1: String = ""
    
    // element의 시작 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "itemList" {
            currentStId = ""
            currentArrmsg1 = ""
            currentStNm = ""
            currentExps1 = ""
        }
    }
    
    // element의 내용을 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "stId":
            currentStId += string
        case "arrmsg1":
            currentArrmsg1 += string
        case "stNm":
            currentStNm += string
        case "exps1":
            currentExps1 += string
        default:
            break
        }
    }
    
    // element의 종료 태그를 만났을 때 호출되는 메서드
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "itemList" {
            let item = Bus(id: currentStId, arrmsg1: currentArrmsg1, stNm: currentStNm, exps1: Int(currentExps1) ?? 0)
            items.append(item)
        }
        
        currentElement = ""
    }
}
