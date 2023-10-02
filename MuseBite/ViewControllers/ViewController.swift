//
//  ViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var postTableView: UITableView!
    @IBOutlet var writePostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    func initUI() {
        // postTableView
        postTableView.dataSource = self
        postTableView.delegate = self
        let postTableViewCell = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(postTableViewCell, forCellReuseIdentifier: "PostTableViewCell")
        // 네비게이션
        self.navigationController?.navigationBar.isHidden = true
        // writePostButton
        writePostButton.layer.cornerRadius = writePostButton.frame.height / 2
    
        if traitCollection.userInterfaceStyle == .light {
            print("라이트 모드")
            writePostButton.layer.shadowColor = UIColor.black.cgColor
            writePostButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            writePostButton.layer.shadowRadius = 4
            writePostButton.layer.shadowOpacity = 0.25
        } else {
            print("다크 모드")
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        if let previousTraitCollection = previousTraitCollection {
//            print(#function)
//            print(previousTraitCollection.userInterfaceStyle == .dark)
//            print(UITraitCollection.current.userInterfaceStyle == .dark)
//        }
        initUI()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        return cell
    }
    
}
