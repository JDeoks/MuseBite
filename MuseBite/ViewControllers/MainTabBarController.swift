//
//  MainTabBarController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        print("MainTabBarController - viewDidLoad")
        super.viewDidLoad()
        self.delegate = self
        initUI()
        // Do any additional setup after loading the view.
    }
    func initUI() {
        self.tabBar.tintColor = UIColor(named: "BLACK")
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        print("MainTabBarController - tabBarController(shouldSelect) index = \(index!)")
//        LoginManager.shared.saveUserLoginStatus(isLoggedIn: false)
        if index == 1 {
            if LoginManager.shared.isUserLoggedIn() == true {
                print("로그인 되어있음")
                let myPageVC = self.storyboard?.instantiateViewController(identifier: "MyPageViewController") as! MyPageViewController
                myPageVC.modalPresentationStyle = .overFullScreen
                self.present(myPageVC, animated: true)
            } else {
                print("로그인 안되어있음")
                let LogInVC = self.storyboard?.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
                LogInVC.modalPresentationStyle = .overFullScreen
                self.present(LogInVC, animated: true)
            }
            return false
        }
        return true
    }

}
