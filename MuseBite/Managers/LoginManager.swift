//
//  LoginManager.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAnalytics

class LoginManager {
    
    /// 싱글톤 인스턴스
    static let shared = LoginManager() /// 싱글톤 인스턴스
    
    let userCollection = Firestore.firestore().collection("user")
    
    private init() {} // 외부에서 인스턴스 생성 방지

    /// 앱 사용자의 로그인 상태 설정
    func setLoginStatus(_ isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: "LoginStatus")
    }
    
    /// 앱 사용자의 로그인 상태 확인
    func getLoginStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoginStatus")
    }
    
    /// 앱 사용자의 UserID 설정
    func setUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: "UserID")
    }
    
    /// 앱 사용자의 UserID 확인
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: "UserID") ?? "UserID 없음"
    }
    
    /// 앱 사용자의 NickName 설정
    func setUserNickName(_ nickName: String) {
        UserDefaults.standard.set(nickName, forKey: "NickName")
    }
    
    /// 앱 사용자의 NickName 확인
    func getUserNickName() -> String {
        return UserDefaults.standard.string(forKey: "NickName") ?? "NickName 없음"
    }
    
    /// 앱 사용자의 OAuthID 설정
    func setOAuthID(_ oauthID: String) {
        UserDefaults.standard.set(oauthID, forKey: "OAuthID")
    }
    
    /// 앱 사용자의 OAuthID  확인
    func getOAuthID() -> String {
        return UserDefaults.standard.string(forKey: "OAuthID") ?? "OAuthID 없음"
    }
    
    /// oauthID 같은 user Doc 검색해서 로그인, 없으면 새 user 생성
    func setUserByOAuthID(oauthID: String) {
        print("LoginManager - setUserByOAuthID(oauthID:)")
        userCollection.whereField("oauthID", isEqualTo: oauthID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                self.setLoginStatus(false)
                print("oauthID로 user 검색 실패 \(err)")
            } else {
                if querySnapshot!.documents.count == 0 {
                    self.signUp(oauthID: oauthID)
                } else {
                    self.signIn(userDoc: querySnapshot!.documents[0])
                }
            }
        }
    }
    
    /// user Doc 생성 후, user 정보 로컬에 저장
    func signUp(oauthID: String) {
        print("LoginManager - signUpWithOAuthID(oauthID:)")
        // TODO: - 회원가입시에 카카오 유저 정보 받아와서 닉네임에 적용 필요
        let nickName = oauthID
        var ref: DocumentReference? = nil
        ref = userCollection.addDocument(data: [
            "createdTime": Timestamp(date: Date()),
            "oauthID": oauthID,
            "nickName": nickName
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.setUserID(ref!.documentID)
                self.setLoginStatus(true)
                self.setOAuthID(oauthID)
                self.setUserNickName(nickName)
            }
        }
    }
    
    /// 회원정보 로컬에 저장
    func signIn(userDoc: QueryDocumentSnapshot) {
        print("LoginManager - signIn(userDoc:)")
        self.setUserID(userDoc.documentID)
        self.setLoginStatus(true)
        self.setOAuthID(userDoc.data()["oauthID"] as! String)
        self.setUserNickName(userDoc.data()["nickName"] as! String)
    }
    
    func signIn(userDoc: DocumentSnapshot) {
        print("LoginManager - signIn(userDoc:)")
        self.setUserID(userDoc.documentID)
        self.setLoginStatus(true)
        self.setOAuthID(userDoc["oauthID"] as! String)
        self.setUserNickName(userDoc["nickName"] as! String)
    }
    
}
