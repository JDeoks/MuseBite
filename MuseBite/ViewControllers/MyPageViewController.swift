//
//  MyPageViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate

class MyPageViewController: UIViewController {
    
    var user: UserModel? = nil
        
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        saveButton.layer.cornerRadius = 8
        nickNameTextField.layer.cornerRadius = 8
        nickNameTextField.text = LoginManager.shared.getUserNickName()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        guard let newNickName = nickNameTextField.text else { return }
        LoginManager.shared.setUserNickName(newNickName)
        uploadUserNickName(nickName: newNickName)
        self.dismiss(animated: true)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        KakaoAuthManager.shared.KakaoLogout()
        self.dismiss(animated: true)
    }

    @IBAction func unLinkButttonClicked(_ sender: Any) {
        // 닉네임을 입력해주세요
        KakaoAuthManager.shared.kakaoUnLink()
    }
    
    func uploadUserNickName(nickName: String) {
        let userID = LoginManager.shared.getUserID()
        let userRef = Firestore.firestore().collection("user").document(userID)
        userRef.updateData([
            "nickName": nickName
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }
    
}
