//
//  FirebaseKAKAOSignInModel.swift
//  Last Project
//
//  Created by 박지환 on 10/31/23.
//

import Foundation
import Firebase
class FirebaseKAKAOSignInModel {
    let db = Firestore.firestore()
    
    func insertItems(name: String, completion: @escaping (Bool) -> Void) {
        // 이미 해당 `userid`가 존재하는지 확인
        db.collection("users").whereField("userid", isEqualTo: name).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking for existing user: \(error)")
                completion(false)
            } else if querySnapshot!.documents.isEmpty {
                // 해당 `userid`가 존재하지 않는 경우에만 추가
                self.db.collection("users").addDocument(data: ["name": name, "password": "", "phone": "", "userid": name]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                // 이미 해당 `userid`가 존재하는 경우
                print("User with the same userid already exists")
                completion(false)
            }
        }
    }
}
