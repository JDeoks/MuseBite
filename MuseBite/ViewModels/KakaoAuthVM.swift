//
//  KakaoAuthVM.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print("KakaoAuthVM - init()")
    }
    
    func handleKakaoLogin() {
        print("KakaoAuthVm - handleKakaoLogin()")
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 실행 가능 -> 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    LoginManager.shared.saveUserLoginStatus(isLoggedIn: true)
                    //do something
                    _ = oauthToken
                }
            }
        } else {
            // 카카오톡 설치 X -> 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")
                        LoginManager.shared.saveUserLoginStatus(isLoggedIn: true)
                        //do something
                        _ = oauthToken
                    }
                }
        }
    }
    
    func KakaoLogout() {
        print("KakaoAuthVm - KakaoLogout()")
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                LoginManager.shared.saveUserLoginStatus(isLoggedIn: false)
            }
        }
    }
}
