//
//  LogInViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class LogInViewController: UIViewController {
    
    lazy var kakaoAuthManager: KakaoAuthManager = { KakaoAuthManager() }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func kakaoLoginButtonClicked(_ sender: Any) {
        kakaoAuthManager.handleKakaoLogin()
        self.dismiss(animated: true)
    }
}
