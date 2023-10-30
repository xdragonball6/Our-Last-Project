//
//  FirebaseDogInsertVM.swift
//  Last Project
//
//  Created by 박지환 on 10/31/23.
//

import Foundation
import Firebase
class FirebaseDogInsertVM {
    let db = Firestore.firestore()
    
    // "seq" 값을 가져오는 메서드
    func getNextSeq(completion: @escaping (Int) -> Void) {
        let seqCollection = db.collection("seq_collection") // 별도의 컬렉션에 "seq" 값을 저장
        let seqDocument = seqCollection.document("seq_document") // "seq" 값을 저장하는 문서
        
        // "seq_document" 문서에서 "seq" 필드를 가져옴
        seqDocument.getDocument { (document, error) in
            if let document = document, let seq = document.data()?["seq"] as? Int {
                completion(seq)
            } else {
                // "seq_document"가 없는 경우 또는 "seq" 필드가 없는 경우
                completion(0) // 기본값
            }
        }
    }
    
    // "seq" 값을 증가시키는 메서드
    func incrementSeq() {
        let seqCollection = db.collection("seq_collection")
        let seqDocument = seqCollection.document("seq_document")
        
        // "seq_document" 문서에서 "seq" 값을 증가시키기 위해 트랜잭션 사용
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let seqDocumentData: [String: Any] = ["seq": FieldValue.increment(Int64(1))]
            transaction.setData(seqDocumentData, forDocument: seqDocument, merge: true)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Error incrementing seq: \(error.localizedDescription)")
            }
        }
    }
    
    // 개 정보를 추가하는 메서드
    func insertItems(name: String, age: String, userid: String, imageurl: String, species: String) {
        // "seq" 값을 가져오고 증가시킴
        getNextSeq { seq in
            // "seq" 값을 사용하여 개 정보를 추가
            let dogData: [String: Any] = [
                "name": name,
                "userid": userid,
                "imageurl": imageurl,
                "seq": seq,
                "species": species,
                "age": age
            ]
            self.db.collection("dogs").addDocument(data: dogData) { error in
                if let error = error {
                    print("Error adding dog data: \(error.localizedDescription)")
                } else {
                    // "seq" 값을 증가시킴
                    self.incrementSeq()
                }
            }
        }
    }
}
