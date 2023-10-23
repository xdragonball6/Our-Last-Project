//
//  FirebaseMainPageImage.swift
//  Last Project
//
//  Created by leeyoonjae on 10/23/23.
//

import Foundation

import Firebase

protocol FirebaseMainPageImageProtocol{
    func itemDownloaded(items: [MainPageDBModel])
}

class FirebaseMainPageImage{
    var delegate: FirebaseMainPageImageProtocol!
    let db = Firestore.firestore()
    
    func MainpageImageItems(){
        var locations: [MainPageDBModel] = []
        db.collection("mainPage").order(by: "image").getDocuments(completion: {(querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }else{
                print("Data is downloaded")
                
                for document in querySnapshot!.documents{
                    guard let data = document.data()["image"] else {return}
                    
                    let query = MainPageDBModel(
                        image: document.data()["image"] as! String
                        )
                    locations.append(query)
                }
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(items: locations)
                }
            }
        })
    }
}
