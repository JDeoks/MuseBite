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

class CommentModel {

    var commentID: String
    var content: String
    var createdTime: Date
    var userID: String
    
    init(document: QueryDocumentSnapshot) {
        self.commentID = document.documentID
        self.content = document.data()["content"] as! String
        self.createdTime = (document.data()["createdTime"] as! Timestamp).dateValue()
        self.userID = document.data()["userID"] as? String ?? "userID 없음"
    }
    
    func getCreateTimeStr() -> String {
        // TODO
        return "10:05"
    }
}
