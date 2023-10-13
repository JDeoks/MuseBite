//
//  AppDelegate.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/09/26.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon
import FirebaseCore
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 파이어베이스 초기화
        FirebaseApp.configure()
        // 네이티브 앱 키를 사용해 iOS SDK를 초기화
        let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: nativeAppKey as! String)
        fetchUserInfo()
        return true
    }
    
    func fetchUserInfo() {
        if LoginManager.shared.getLoginStatus() == true {
            let userID = LoginManager.shared.getUserID()
            let userRef = Firestore.firestore().collection("user").document(userID)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    LoginManager.shared.signIn(userDoc: document)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }

}

