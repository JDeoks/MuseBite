//
//  DataManager.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics

class DataManager {
    
    static let shared = DataManager()
    private init() { }
    
    var postList: [PostModel] = []
    
    func fetchRecentPostData(handler: @escaping ()->()) {
        print("CommunityViewController - fetchRecentPostData()")
        // Firestore 콜렉션 초기화
        let postCollection = Firestore.firestore().collection("post").order(by: "createdTime", descending: true)
        // 콜렉션의 도큐먼트들을 가져와서 배열에 저장
        postCollection.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
                // 에러 처리: 사용자에게 메시지 표시 또는 기록
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            // 배열 초기화
            self.postList.removeAll()
            // 배열에 있는 각 도큐먼트에 접근하거나 처리
            for document in documents {
                let documentData = document.data()
                // 도큐먼트 데이터 확인
                print("Document data: \(documentData)")
                // TODO: 파싱하는건 VC가 안함
                let title = documentData["title"] as! String
                let desc = documentData["desc"] as! String
                let createdTime = documentData["createdTime"] as! Timestamp
                let post = PostModel(id: document.documentID, title: title, desc: desc, createdTime: createdTime.dateValue())
                self.postList.append(post)
                
            }
            // UI 업데이트를 메인 스레드에서 수행
//            DispatchQueue.main.async {
//                self.postTableView.reloadData()
//            }
            
            handler()
        }
    }
    
}
