//
//  UploadViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics

class UploadViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextField: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func uploadPost() {
        let postCollection = Firestore.firestore().collection("post")
        var ref: DocumentReference? = nil
        ref = postCollection.addDocument(data: [
            "title": titleTextField.text ?? "",
            "desc": descTextField.text ?? "",
            "createdTime": Timestamp(date: Date()),
            "userID": LoginManager.shared.getUserID(),
            "userNickName": LoginManager.shared.getUserNickName()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                DataManager.shared.fetchRecentPostData()
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if titleTextField.text == "" {
            // TODO:  제목을 입력하세요
            return
        }
        uploadPost()
    }
}
