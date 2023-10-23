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
        
    func insertItems(userid: String, name: String, password: String, phone: String, completion: @escaping (Bool) -> Void) {
            // Firebase에서 해당 userid로 사용자가 이미 존재하는지 확인
            Auth.auth().fetchSignInMethods(forEmail: userid) { [self] (methods, error) in
                if let error = error {
                    print("Error checking for existing user: \(error.localizedDescription)")
                    completion(false)
                } else if let methods = methods, !methods.isEmpty {
                    // 이미 해당 userid로 사용자가 존재하는 경우
                    print("User already exists with this userid")
                    completion(false)
                } else {
                    // 해당 userid로 사용자가 존재하지 않는 경우, Firestore에 저장
                    db.collection("users").whereField("userid", isEqualTo: userid).getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error querying Firestore: \(error.localizedDescription)")
                            completion(false)
                        } else if let snapshot = snapshot, !snapshot.isEmpty {
                            // 이미 해당 userid로 문서가 존재하는 경우
                            print("Document with this userid already exists in Firestore")
                            completion(false)
                        } else {
                            // 해당 userid로 사용자가 존재하지 않고 Firestore에도 데이터가 없는 경우
                            db.collection("users").addDocument(data: [
                                "userid": userid,
                                "name": name,
                                "password": password,
                                "phone": phone
                            ]) { error in
                                if let error = error {
                                    print("Error adding user: \(error.localizedDescription)")
                                    completion(false)
                                } else {
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
