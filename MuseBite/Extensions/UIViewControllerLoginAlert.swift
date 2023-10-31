//
//  UIViewControllerLoginAlert.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/11/01.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoginRequiredAlert() {
        let sheet = UIAlertController(title: "로그인 후 이용 가능한 서비스입니다.", message: "로그인으로 더 많은 서비스를 사용해보세요.", preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "로그인", style: .default, handler: { _ in
            print("yes 클릭")
            let LogInVC = self.storyboard?.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
            LogInVC.modalPresentationStyle = .overFullScreen
            self.present(LogInVC, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        sheet.addAction(loginAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
    }
}
