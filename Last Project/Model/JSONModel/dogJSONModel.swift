//
//  dogJSONModel.swift
//  Last Project
//
//  Created by 박지환 on 10/25/23.
//

import Foundation
struct dogData: Decodable {
    let result: [dog]
}


struct dog: Decodable {
    let userid: String
    let dog_name: String
    let species: String
    let dog_image: String
}
