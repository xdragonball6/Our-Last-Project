//
//  FirebaseMainPageBtn.swift
//  Last Project
//
//  Created by leeyoonjae on 10/23/23.
//

import Foundation

import Firebase

protocol FirebaseMainPageBtnProtocol{
    func itemDownloaded(items: [FirebaseMainPageBtnModel])
}

class FirebaseMainPageBtn {
    var delegate: FirebaseMainPageBtnProtocol?

    let db = Firestore.firestore()

    func MainpageImageBtn(){
        var locations: [FirebaseMainPageBtnModel] = []
        db.collection("mainPageBtn").order(by: "image").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Data is downloaded")

                for document in querySnapshot!.documents {
                    guard let image = document.data()["image"] as? String,
                          let name = document.data()["name"] as? String,
                          let image2 = document.data()["image2"] as? String
                    else {
                        continue
                    }
                    // print("Image URL2: \(image2)")
                    let query = FirebaseMainPageBtnModel(image: image, name: name, image2: image2)
                    locations.append(query)
                }
                self.delegate?.itemDownloaded(items: locations)
            }
        })
    }
}


//class FirebaseMainPageBtn {
//    var delegate: FirebaseMainPageBtnProtocol?
//
//    let db = Firestore.firestore()
//
//    func MainpageImageBtn(){
//        var locations: [FirebaseMainPageBtnModel] = []
//        db.collection("mainPageBtn").order(by: "image").getDocuments(completion: { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                print("Data is downloaded")
//
//                for document in querySnapshot!.documents {
//                    guard let image = document.data()["image"] as? String,
//                          let name = document.data()["name"] as? String,
//                          let image2 = document.data()["image2"] as? String
//                    else {
//                        continue
//                    }
//                    // print("Image URL: \(image)")
//                    let query = FirebaseMainPageBtnModel(image: image, name: name, image2: image2)
//                    locations.append(query)
//                }
//                self.delegate?.itemDownloaded(items: locations)
//            }
//        })
//    }
//
//}
