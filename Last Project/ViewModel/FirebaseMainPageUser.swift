//
//  FirebaseMainPageUser.swift
//  Last Project
//
//  Created by leeyoonjae on 10/29/23.
//

import Foundation
import Firebase

protocol FirebaseMainPageUserProtocol {
    func itemDownloaded(items: [FirebaseMainPageUserModel])
}

class FirebaseMainPageUser {
    var delegate: FirebaseMainPageUserProtocol?
    
    let db = Firestore.firestore()
    
    func MainPageUser() {
        var locations: [FirebaseMainPageUserModel] = []
        db.collection("users").order(by: "userid").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("문서를 가져오는 중 오류 발생: \(err)")
            } else {
                print("데이터 다운로드 완료 1")

                for document in querySnapshot!.documents {
                    guard let userid = document.data()["userid"] as? String,
                          let name = document.data()["name"] as? String,
                          let password = document.data()["password"] as? String,
                          let phone = document.data()["phone"] as? String 
                    else {
                        continue
                    }
                    print("사용자 ID: \(userid)")
                    let query = FirebaseMainPageUserModel(name: name, password: password, phone: phone, userid: userid)
                    locations.append(query)
                }
                self.delegate?.itemDownloaded(items: locations)
            }
        })
    }
}
