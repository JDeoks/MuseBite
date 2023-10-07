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

class PostModel {
    /// Post 고유 아이디
    var id: String
    var title: String
    var desc: String
    var createdTime: Date
    var writer: String
//    var audioURL: URL?
//    var startTime: Int?
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.title = document.data()["title"] as! String
        self.desc = document.data()["desc"] as! String
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.writer = ""//document.data()["writer"] as! String
    }
    
    func getCreateTimeStr() -> String {
        // TODO
        return "10:05"
    }
}
