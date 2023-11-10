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
    
    var currentPost: PostModel?
    
    /// NotificationViewController
    let getPostByIdDone = PublishSubject<Void>()

    func getPostById(postId: String) {
        print("DataManager - getPostById")
        
        let postDocRef =  Firestore.firestore().collection("post").document(postId)
        postDocRef.getDocument { (document, error) in
          if let document = document, document.exists {
              self.currentPost = PostModel(document: document)
              self.getPostByIdDone.onNext(())
          } else {
            print("post Document does not exist")
          }
        }
    }
}
    
