//
//  PostModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import Foundation

class PostModel {
    /// Post 고유 아이디
    var id: String
    var title: String
    var desc: String
    private var createdTime: Date
//    var writer: String?
//    var audioURL: URL?
//    var startTime: Int?
    
    init(id: String, title: String, desc: String, createdTime: Date) {
        self.id = id
        self.title = title
        self.desc = desc
        self.createdTime = createdTime
    }
    
    func getCreateTimeStr() -> String {
        // TODO
        return "10:05"
    }
}
