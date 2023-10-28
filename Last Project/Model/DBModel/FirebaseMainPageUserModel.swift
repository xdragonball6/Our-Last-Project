//
//  FirebaseMainPageUserModel.swift
//  Last Project
//
//  Created by leeyoonjae on 10/29/23.
//

import Foundation

struct FirebaseMainPageUserModel{
    var name: String
    var password: String
    var phone: String
    var userid: String
    init(name: String, password: String, phone: String, userid: String) {
        self.name = name
        self.password = password
        self.phone = phone
        self.userid = userid
    }
}
