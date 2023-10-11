//
//  CommentModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/08.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate

class CommentModel {

    var commentID: String
    var content: String
    var createdTime: Date
    var userID: String
    var userNickName: String
    
    init(document: QueryDocumentSnapshot) {
        self.commentID = document.documentID
        self.content = document.data()["content"] as! String
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.userID = document.data()["userID"] as? String ?? "userID 없음"
        self.userNickName =  document.data()["userNickName"] as? String ?? "userNickName 없음"
    }
    
    func getCreateTimeStr() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean)
        return DateInRegion(self.createdTime, region: region).toFormat("yyyy-MM-dd HH:mm")
    }
}
