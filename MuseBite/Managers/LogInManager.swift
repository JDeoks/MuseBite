//
//  LogInManager.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics

class LoginManager {
    
    static let shared = LoginManager() // 싱글톤 인스턴스
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    // 사용자 로그인 상태 저장
    func saveUserLoginStatus(isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
    }
    
    // 사용자 로그인 상태 가져오기
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsLoggedIn")
    }
    
    func setUserByOAuthID(oauthID: String) {
        print("LoginManager - setUserByOAuthID(oauthID:)")
        UserDefaults.standard.set(oauthID, forKey: "UserOAuthID")
        let userCollection = Firestore.firestore().collection("user")
        userCollection.whereField("oauthID", isEqualTo: oauthID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0 {
                        print("신규 가입 유저")
                        var ref: DocumentReference? = nil
                        // TODO: - 닉네임 추가 수정
                        let nickName = String(oauthID.prefix(10))
                        self.setUserNickName(nickName: nickName)
                        ref = userCollection.addDocument(data: [
                            "createdTime": Timestamp(date: Date()),
                            "oauthID": oauthID,
                            "nickName": nickName
                        ]) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                                self.setUserID(userID: ref!.documentID)
                            }
                        }
                    }
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
        
    }
    
    func setUserID(userID: String) {
        UserDefaults.standard.set(userID, forKey: "UserID")
    }
    
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: "UserID") ?? "UserID 없음"
    }
    
    func setUserNickName(nickName: String) {
        UserDefaults.standard.set(nickName, forKey: "NickName")
    }
    
    func getUserNickName() -> String {
        return UserDefaults.standard.string(forKey: "NickName") ?? "NickName 없음"
    }
}
