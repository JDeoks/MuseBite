//
//  UserModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/08.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate

class UserModel {
    
    /// user Doc 고유 아이디
    var userID: String
    var createdTime: Date
    var oauthID: String
    var nickName: String

    init(document: QueryDocumentSnapshot) {
        self.userID = document.documentID
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.oauthID = document.data()["oauthID"] as! String
        self.nickName = document.data()["nickName"] as! String
    }
    
    func getCreateTimeStr() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.asiaSeoul, locale: Locales.korean)
        return DateInRegion(self.createdTime, region: region).toFormat("yyyy-MM-dd HH:mm")
    }
}
