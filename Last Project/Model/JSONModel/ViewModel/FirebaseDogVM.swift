//
//  FirebaseDogVM.swift
//  Last Project
//
//  Created by 박지환 on 10/30/23.
//
import Foundation
import Firebase
protocol FirebaseDogQueryModelProtocol{
    func itemDownloaded(items: [FirebaseDogDBModel])
}

class FirebaseDogQueryModel{
    var delegate: FirebaseDogQueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(){
        print(SignIn.userID)
        var locations: [FirebaseDogDBModel] = []
        db.collection("dogs")
            .whereField("userid", isEqualTo: SignIn.userID)
            .order(by: "name").getDocuments(completion: {(QuerySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                }else{
                    print("Data is downloaded")
                    
                    for documnet in QuerySnapshot!.documents{
                        guard let data = documnet.data()["name"] else {return}
                        print("\(documnet.documentID) => \(data)")
                        let query = FirebaseDogDBModel(userid: documnet.data()["userid"] as! String,
                                                       name: documnet.data()["name"] as! String,
                                                       age: documnet.data()["age"] as! String,
                                                       species: documnet.data()["species"] as! String,
                                                       imageurl: documnet.data()["imageurl"] as! String,
                                                       seq: documnet.data()["seq"] as! Int
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
