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

class KakaoAuthManager: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print("KakaoAuthManager - init()")
    }
    
    func handleKakaoLogin() {
        print("KakaoAuthManager - handleKakaoLogin()")
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            kakaoLoginWithApp()
        } else {
            // TODO: 웹로그인 기능도 추가해야함
            // 카카오톡 설치 X -> 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    LoginManager.shared.setLoginStatus(true)
                    //do something
                    _ = oauthToken
                    print("kakao_\(String(describing: oauthToken!.idToken))")
                }
            }
        }
    }
    
    func kakaoLoginWithApp() {
        print("KakaoAuthManager - kakaoLoginWithApp()")
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print(oauthToken!)
                print("kakaoLoginWithApp() success.")
                self.getUserOAuthID()
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
                LoginManager.shared.setLoginStatus(false)
            }
        }
    }
    
    func getUserOAuthID() {
        print("KakaoAuthVm - getUserOAuthID()")
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("OAuthID = kakao_\(String(describing: user!.id))")
                return LoginManager.shared.setUserByOAuthID(oauthID: "kakao_\(String(describing: user!.id!))")
            }
        }
    }
}
