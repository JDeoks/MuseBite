//
//  NotificationViewModel.swift
//  MuseBite
//
//  Created by 서정덕 on 11/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import RxSwift

class NotificationViewModel {
    
    var notifications: [NotificationModel] = []
    var currentPost: PostModel?
    
    /// NotificationViewController
    let fetchNotificationsDataDone = PublishSubject<Void>()
    /// NotificationViewController
    let getPostByIdDone = PublishSubject<Void>()
    /// NotificationViewController
    let showDeletedPost = PublishSubject<Void>()
    
    func fetchNotificationsData() {
        print("NotificationViewModel - fetchNotificationsData()")
        
        let userID = LoginManager.shared.getUserID()
        let commentQuery = Firestore.firestore().collection("notification").whereField("userID", isEqualTo: userID).order(by: "createdTime", descending: true)
        commentQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            self.notifications.removeAll()
            for document in documents {
                let noti = NotificationModel(document: document)
                self.notifications.append(noti)
            }
            self.fetchNotificationsDataDone.onNext(())
        }
    }
    
    func getPostById(postId: String) {
        print("NotificationViewModel - getPostById")
        
        let postDocRef =  Firestore.firestore().collection("post").document(postId)
        postDocRef.getDocument { (document, error) in
          if let document = document, document.exists {
              self.currentPost = PostModel(document: document)
              self.getPostByIdDone.onNext(())
          } else {
              self.showDeletedPost.onNext(())
          }
        }
    }
    
}
    
