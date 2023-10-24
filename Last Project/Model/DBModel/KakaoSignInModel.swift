//
//  SignInModel.swift
//  HomeWork_JSON
//
//  Created by 박지환 on 2023/10/27.
//
import Foundation
import Firebase
class KaKaoSignInModel{
        let db = Firestore.firestore()
        
    func insertItems(name: String, phone: String, address: String) -> Bool{
            var status: Bool = true
        db.collection("users").addDocument(data: ["name": name,"phone": phone, "address":address]){error in
                if error != nil{
                    status = false
                }else{
                    status = true
                }
            }
            return status
        }
    }
