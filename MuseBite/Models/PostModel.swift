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
    var userNickName: String
    var likes: Int
    var dislikes: Int
    var comments: Int
//    var audioURL: URL?
//    var startTime: Int?
    
    init(document: DocumentSnapshot) {
        self.postID = document.documentID
        self.title = document.data()!["title"] as! String
        self.desc = document.data()!["desc"] as! String
        self.createdTime = (document.data()!["createdTime"] as! Timestamp).dateValue()
        self.userID = document.data()!["userID"] as? String ?? "userID 없음"
        self.userNickName = document.data()!["userNickName"] as? String ?? "닉네임 없음"
        self.likes = document.data()!["likes"] as? Int ?? 0
        self.dislikes = document.data()!["dislikes"] as? Int ?? 0
        self.comments = document.data()!["comments"] as? Int ?? 0
    }
    
    func getCreateTimeStr() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean)
        return DateInRegion(self.createdTime, region: region).toFormat("yyyy-MM-dd HH:mm")
    }
}
