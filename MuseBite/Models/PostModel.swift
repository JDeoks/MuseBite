//
//  PostModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate

class PostModel {

    var postID: String
    var title: String
    var desc: String
    var createdTime: Date
    var userID: String
//    var audioURL: URL?
//    var startTime: Int?
    
    init(document: QueryDocumentSnapshot) {
        self.postID = document.documentID
        self.title = document.data()["title"] as! String
        self.desc = document.data()["desc"] as! String
        print((document.data()["createdTime"] as! Timestamp).dateValue())
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.userID = document.data()["userID"] as? String ?? "userID 없음"
    }
    
    func getCreateTimeStr() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean)
        return DateInRegion(self.createdTime, region: region).toFormat("yyyy-MM-dd HH:mm")
    }
}
