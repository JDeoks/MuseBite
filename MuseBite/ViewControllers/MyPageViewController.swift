//
//  MyPageViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class MyPageViewController: UIViewController {

    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM() }()
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nickNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        saveButton.layer.cornerRadius = 8
        nickNameTextField.layer.cornerRadius = 8
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        kakaoAuthVM.KakaoLogout()
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
