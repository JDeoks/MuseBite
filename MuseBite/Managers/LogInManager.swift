//
//  LogInManager.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import Foundation

class LoginManager {
    static let shared = LoginManager() // 싱글톤 인스턴스
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    // 사용자 로그인 상태 저장
    func saveUserLoginStatus(isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
    }
    
    // 사용자 로그인 상태 가져오기
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
