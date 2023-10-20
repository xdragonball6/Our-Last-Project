//
//  SignInModel.swift
//  HomeWork_JSON
//
//  Created by 박지환 on 2023/08/27.
//
import Foundation
import Firebase
class FirebaseSignInModel{
    let db = Firestore.firestore()
    
    func insertItems(userid : String, name: String, password: String, phone: String) -> Bool{
        var status: Bool = true
        db.collection("users").addDocument(data: ["userid": userid,
                                                     "name": name,
                                                     "password": password,
                                                     "phone": phone]){error in
            if error != nil{
                status = false
            }else{
                status = true
            }
        }
        return status
    }
}
