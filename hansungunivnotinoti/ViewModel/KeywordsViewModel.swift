//
//  KeywordsViewModel.swift
//  hansungunivnotinoti
//
//  Created by Finny Jakey on 2023/06/27.
//

import Foundation
import FirebaseDatabase
import FirebaseFunctions

class KeywordsViewModel: ObservableObject {
    @Published var keywords: [String] = []
    @Published var state: LoadingState = .idle

    let ref: DatabaseReference? = Database.database().reference()
    let functions: Functions = Functions.functions()
    
    func addNewKeyword(deviceToken: String, keyword: String) {
        let data: [String: Any] = [
            "deviceToken": deviceToken,
            "keyword": keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ]
        
        functions.httpsCallable("subscribeKeyword").call(data) { result, error in
            if let error = error as NSError? {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = result?.data as? [String: Any],
                let result = data["result"] as? Bool {
                if result {
                    print("Successfully subscribed to keyword")
                } else {
                    print("Failed to subscribe to keyword")
                    return
                }
            }
        }
        
        ref?.child("KeyWords").child("\(keyword)").updateChildValues([
            deviceToken: keyword
        ])
    }
    
    func deleteKeyword(deviceToken: String, keyword: String) {
        let data: [String: Any] = [
            "deviceToken": deviceToken,
            "keyword": keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        ]

        functions.httpsCallable("unsubscribeKeyword").call(data) { result, error in
            if let error = error as NSError? {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = result?.data as? [String: Any], let result = data["result"] as? Bool {
                if result {
                    print("Successfully unsubscribed from keyword")
                } else {
                    print("Failed to unsubscribe from keyword")
                    return
                }
            }
        }
        
        ref?.child("KeyWords/\(keyword)/\(deviceToken)").removeValue()
    }
    
    func getAllKeywords(deviceToken: String) {
        keywords.removeAll()
        ref?.child("KeyWords").observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                for (key, value) in data {
                    let value_dict_array = value as! Dictionary<String,Any>
                    
                    for single_data in value_dict_array {
                        if single_data.key == deviceToken {
                            self.keywords.append(key)
                            break
                        }
                    }
                }
            }
            self.state = .loaded
        }
    }
}

extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}
