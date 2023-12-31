//
//  UploadViewModel.swift
//  MuseBite
//
//  Created by 서정덕 on 11/7/23.
//

import Foundation
import RxSwift

class UploadViewModel {
    
    let uploadDone = PublishSubject<Void>()
    
    func upload(title: String, desc: String) {
        DataManager.shared.uploadPost(title: title, desc: desc, completion: {
            DataManager.shared.fetchRecentPostData()
            self.uploadDone.onNext(())
        })
    }
}
    
