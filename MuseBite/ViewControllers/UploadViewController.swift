//
//  UploadViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import RxSwift
import RxKeyboard

class UploadViewController: UIViewController {
    
    let uploadVM = UploadViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextField: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func initUI () {

    }

    func actions() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(onNext: { keyboardVisibleHeight in
                self.textStackView.snp.updateConstraints { make in
                    UIView.animate(withDuration: 1) {
                        make.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    func bind() {
        uploadVM.uploadDone
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if titleTextField.text == "" {
            // TODO:  제목을 입력하세요
            return
        }
        uploadVM.upload(title: titleTextField.text!, desc: descTextField.text!)
    }
}
