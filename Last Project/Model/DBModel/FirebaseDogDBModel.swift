//
//  FirebaseDogModel.swift
//  Last Project
//
//  Created by 박지환 on 10/30/23.
//

import Foundation

class FirebaseDogDBModel{
    var userid: String
    var name: String
    var age: String
    var species: String
    var imageurl: String
    var seq: Int
    
    init(userid: String, name: String, age: String, species: String, imageurl: String, seq: Int) {
        self.userid = userid
        self.name = name
        self.age = age
        self.species = species
        self.imageurl = imageurl
        self.seq = seq
    }

}
