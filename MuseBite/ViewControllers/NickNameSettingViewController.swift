//
//  NickNameSettingViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/11.
//

import UIKit
import RxSwift
import RxCocoa

class NickNameSettingViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = NickNameSettingViewModel()
    
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        action()
    }
    
    // UI 이벤트 구독
    private func action() {
        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.generateUser()
            })
            .disposed(by: disposeBag)
    }
    
    /// 뷰모델의 옵저버블 구독
    private func bind() {
        viewModel.validation
            .subscribe(onNext: { isValid in
                self.startButton.isEnabled = isValid
                self.startButton.backgroundColor = isValid ? .blue : .gray
            })
            .disposed(by: disposeBag)
        
        viewModel.isSuccess
            .subscribe(onNext: { _ in
                // TODO
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMsg
            .subscribe(onNext: { msg in
                print(msg)
            })
            .disposed(by: disposeBag)
    }
}
