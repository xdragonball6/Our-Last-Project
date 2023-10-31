//
//  FirebaseMainPageReservationListListModel.swift
//  Last Project
//
//  Created by leeyoonjae on 10/31/23.
//

import Foundation


struct FirebaseMainPageReservationListListModel {
    var documentID: String // Firebase 문서의 고유 ID
    var day: Int
    var department: String
    var image: String
    var symptom: String
    var userid: String
    var year: String

    init(documentID: String, day: Int, department: String, image: String, symptom: String, userid: String, year: String) {
        self.documentID = documentID
        self.day = day
        self.department = department
        self.image = image
        self.symptom = symptom
        self.userid = userid
        self.year = year
    }
}
