//
//  FirebaseDogDeleteVM.swift
//  Last Project
//
//  Created by 박지환 on 10/31/23.
//

import Foundation
import Firebase
class FirebaseDogDeleteVM{
    let db = Firestore.firestore()
    
    
    func deleteItems(name: String, seq: Int) -> Bool {
        var status: Bool = true
        // "dogs" 컬렉션에서 "seq"와 "name"이 일치하는 문서 검색
        db.collection("dogs")
            .whereField("seq", isEqualTo: seq)
            .whereField("name", isEqualTo: name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    status = false
                } else {
                    // 검색 결과를 순회하면서 해당 문서 삭제
                    for document in querySnapshot!.documents {
                        document.reference.delete { error in
                            if let error = error {
                                print("Error delete document: \(error)")
                                status = false
                            } else {
                                print("Document deleted successfully")
                            }
                        }
                    }
                }
            }
        return status
    }
}
