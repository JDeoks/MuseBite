//
//  MyPageViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class MyPageViewController: UIViewController {
    
    var user: UserModel? = nil
    
    lazy var kakaoAuthVM: KakaoAuthManager = { KakaoAuthManager() }()
    
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
        self.dismiss(animated: true)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        kakaoAuthVM.KakaoLogout()
        self.dismiss(animated: true)
    }

}
