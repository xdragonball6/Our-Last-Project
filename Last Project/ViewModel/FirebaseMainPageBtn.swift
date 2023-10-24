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
                          let name = document.data()["name"] as? String else {
                        continue
                    }
                    let query = FirebaseMainPageBtnModel(image: image, name: name)
                    locations.append(query)
                }
                self.delegate?.itemDownloaded(items: locations)
            }
        })
    }

}