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
import RxSwift

class DataManager {
    
    static let shared = DataManager()
    private init() { }
    
    var posts: [PostModel] = []
    
    ///fetchRecentPostData 성공여부 플래그
    let fetchDataDone = PublishSubject<Void>()
    
    func fetchRecentPostData() {
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
            self.posts.removeAll()
            // 배열에 있는 각 도큐먼트에 접근
            for document in documents {
                let post = PostModel(document: document)
                self.posts.append(post)
            }
            fetchDataDone.onNext(())
        }
    }
    
    func getUser(userID: String) -> String {
        let userCollection = Firestore.firestore().collection("user")
        let doc = userCollection.document(userID)
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                return 
            } else {
                print("Document does not exist")
            }
        }
        return "hello"
    }
    
    func fetchCommentsData() {
        
    }

}
