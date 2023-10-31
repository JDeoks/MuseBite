//
//  PostDetailViewModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import RxSwift

class PostDetailViewModel {
    
    var comments: [CommentModel] = []
    /// fetchRecentPostData 성공여부 플래그
    let fetchCommentDone = PublishSubject<Void>()
    
    func fetchRecentCommentData(postID: String) {
        print("PostDetailViewController - fetchRecentCommentData()")
        let commentQuery = Firestore.firestore().collection("comment").whereField("postID", isEqualTo: postID).order(by: "createdTime", descending: false)
        commentQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                // 에러 처리: 사용자에게 메시지 표시 또는 기록
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            self.comments.removeAll()
            for document in documents {
                let comment = CommentModel(document: document)
                self.comments.append(comment)
            }
            // 패치 완료를 알림
            self.fetchCommentDone.onNext(())
        }
    }
    
    func uploadComment(comment: String, postID: String) {
        let commentCollection = Firestore.firestore().collection("comment")
        var ref: DocumentReference? = nil
        ref = commentCollection.addDocument(data: [
            "content": comment,
            "createdTime": Timestamp(date: Date()),
            "userID": LoginManager.shared.getUserID(),
            "userNickName": LoginManager.shared.getUserNickName(),
            "postID": postID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.fetchRecentCommentData(postID: postID)
            }
        }
        
    }
}
