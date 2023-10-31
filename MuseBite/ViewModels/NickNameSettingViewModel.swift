//
//  NickNameSettingViewModel.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/31.
//

import Foundation
import RxSwift

class NickNameSettingViewModel {
    let disposeBag = DisposeBag()
    
    let nickname = BehaviorSubject(value: "")
    let validation = BehaviorSubject(value: false)
    let isSuccess = PublishSubject<Void>()
    let errorMsg = PublishSubject<String>()
    
    init() {
        nickname
            .subscribe(onNext: { text in
                self.validation.onNext(!text.isEmpty)
            })
            .disposed(by: disposeBag)
    }
    
    func generateUser() {
        // TODO
        
        var isSuccess = true
        
        if isSuccess {
            self.isSuccess.onNext(())
        } else {
            self.errorMsg.onNext("Something wrong")
        }
    }
}
