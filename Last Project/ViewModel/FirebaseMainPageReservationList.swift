//
//  FirebaseMainPageReservationList.swift
//  Last Project
//
//  Created by leeyoonjae on 10/26/23.
//

import Foundation

import Firebase

protocol FirebaseMainPageReservationListProtocol{
    func itemDownloaded(items: [FirebaseMainPageReservationListModel])
}

class FirebaseMainPageReservationList{
    var delegate: FirebaseMainPageReservationListProtocol?
    
    let db = Firestore.firestore()
    
    func MainPageReservationList(){
        var locations: [FirebaseMainPageReservationListModel] = []
        db.collection("mainPageDown").order(by: "image").getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Data is downloaded 1")

                for document in querySnapshot!.documents {
                    guard let image = document.data()["image"] as? String else {
                        continue
                    }
                    print("Image URL: \(image)")
                    let query = FirebaseMainPageReservationListModel(image: image)
                    locations.append(query)
                }
                self.delegate?.itemDownloaded(items: locations)
            }
        })
    }

}
