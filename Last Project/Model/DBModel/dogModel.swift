//
//  petModel.swift
//  Last Project
//
//  Created by 박지환 on 10/25/23.
//

import Foundation
struct dogModel{
    var userid: String
    var dog_name: String
    var species: String
    var dog_image: String
    
    init(userid: String, dog_name: String, species: String, dog_image: String) {
        self.userid = userid
        self.dog_name = dog_name
        self.species = species
        self.dog_image = dog_image
    }
}


