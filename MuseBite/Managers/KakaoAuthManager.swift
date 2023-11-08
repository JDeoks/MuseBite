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
    
    static let shared = KakaoAuthManager()
    
    private init() { }

    var subscriptions = Set<AnyCancellable>()
    
    func handleKakaoLogin() {
        print("KakaoAuthManager - handleKakaoLogin()")
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            kakaoLoginWithApp()
        } else {
            // TODO: 웹로그인 기능도 추가해야함
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    LoginManager.shared.setLoginStatus(true)
                    _ = oauthToken
                }
            }
        }
    }
    
    func kakaoLoginWithApp() {
        print("KakaoAuthManager - kakaoLoginWithApp()")
        // 여기서 UserApi 싱글톤 객체에 카카오 로그인 정보 저장됨
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print(oauthToken!)
                print("kakaoLoginWithApp() success.")
                // TODO: - 여기말고 닉네임
                self.getUserOAuthID()
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
                LoginManager.shared.setUserByOAuthID(oauthID: "kakao_\(String(describing: user!.id!))")
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

    func kakaoUnLink(){
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
}
