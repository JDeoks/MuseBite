//
//  NotificationModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/14.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate

class NotificationModel {
    
    var notificationID: String
    var postID: String
    var createdTime: Date
    var userID: String
    var title: String
    var comment: String
    var commentUserNickName: String
    
    init(document: QueryDocumentSnapshot) {
        self.notificationID = document.documentID
        self.postID = document.data()["postID"] as! String
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.userID = document.data()["userID"] as! String
        self.title = document.data()["title"] as! String
        self.comment = document.data()["comment"] as! String
        self.commentUserNickName = document.data()["commentUserNickName"] as! String
    }
    
    func getCreateTimeStr() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean)
        return DateInRegion(self.createdTime, region: region).toFormat("yyyy-MM-dd HH:mm")
    }
    
}
