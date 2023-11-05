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
    
    var postID: String = ""
    var postData: PostModel? = nil
    var comments: [CommentModel] = []
    
    let fetchPostDataDone = PublishSubject<Void>()
    let fetchRecentCommentDataDone = PublishSubject<Void>()
    let showLoginRequired = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init() {
        
    }
    
    func setPostData(post: PostModel) {
        postID = post.postID
        postData = post
    }
    
    func fetchPostData() {
        print("PostDetailViewModel - fetchPostData()")
        let postDoc = Firestore.firestore().collection("post").document(postID)
        postDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                self.postData = PostModel(document: document)
                self.fetchPostDataDone.onNext(())
            } else {
                print("Document 'post' does not exist")
            }
        }
    }
    
    func fetchRecentCommentData() {
        print("PostDetailViewModel - fetchRecentCommentData()")
        let commentQuery = Firestore.firestore().collection("comment").whereField("postID", isEqualTo: postID).order(by: "createdTime", descending: false)
        commentQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
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
            self.fetchRecentCommentDataDone.onNext(())
        }
    }
    
    func uploadComment(comment: String) {
        print("PostDetailViewModel - uploadComment(comment:)")
        // 로그인 상태 상태 아닐 시
        if LoginManager.shared.getLoginStatus() == false {
            showLoginRequired.onNext(())
            return
        }
        
        if comment == "" { return }
        
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
//                self.uploadCommentDone.onNext(())
                self.registerNotification(comment: comment)
                self.fetchRecentCommentData()
            }
        }
    }
    
    func registerNotification(comment: String) {
        print("PostDetailViewModel - registerNotification(comment:)")

        if comment == "" { return }
        let notiCollection = Firestore.firestore().collection("notification")
        var ref: DocumentReference? = nil
        ref = notiCollection.addDocument(data: [
            "createdTime": Timestamp(date: Date()),
            "userID": self.postData?.userID,
            "postID": postID,
            "title": self.postData!.title,
            "comment": comment,
            "commentUserNickName": LoginManager.shared.getUserNickName()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.fetchRecentCommentData()
            }
        }
    }
}
