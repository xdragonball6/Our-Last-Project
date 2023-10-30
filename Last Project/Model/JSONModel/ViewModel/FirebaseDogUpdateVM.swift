//
//  FirebaseDogUpdateVM.swift
//  Last Project
//
//  Created by 박지환 on 10/31/23.
//

import Foundation
import Firebase

// 쿼리문 작성 하는 곳
class FirebaseDogUpdateVM {
    let db = Firestore.firestore()
    
    func updateItem(name: String, seq: Int) -> Bool {
        var status: Bool = true
        
        // 해당 seq 값을 가진 문서를 찾아 업데이트
        db.collection("dogs").whereField("seq", isEqualTo: seq).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                status = false
            } else {
                for document in querySnapshot!.documents {
                    // 찾은 문서를 업데이트
                    document.reference.updateData(["name": name]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            status = false
                        }
                    }
                }
            }
        }
        
        return status
    }
}

