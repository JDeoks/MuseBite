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

class UploadViewController: UIViewController {
    
    let uploadVM = UploadViewModel()
    let disposBag = DisposeBag()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        uploadVM.uploadDone
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposBag)
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
