//
//  CommunityViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/09/26.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import RxSwift

class CommunityViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet var postTableView: UITableView!
    @IBOutlet var writePostButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        reloadData()
    }
    
    // 다크, 라이트 모드 변경시 호출되는 함수
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        initUI()
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        reloadData()
        refreshControl.endRefreshing()
    }
    
    func initUI() {
        // refreshControl
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        // postTableView
        postTableView.dataSource = self
        postTableView.delegate = self
        let postTableViewCell = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(postTableViewCell, forCellReuseIdentifier: "PostTableViewCell")
        postTableView.refreshControl = refreshControl
        // 네비게이션
        self.navigationController?.navigationBar.isHidden = true
        // writePostButton
        writePostButton.layer.cornerRadius = writePostButton.frame.height / 2
        // 화면 테마
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
    
    func bind() {
        DataManager.shared.fetchDataDone
            .subscribe(onNext: { _ in
                self.postTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func reloadData() {
        DataManager.shared.fetchRecentPostData()
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let uploadVC = self.storyboard?.instantiateViewController(identifier: "UploadViewController") as! UploadViewController
        uploadVC.hidesBottomBarWhenPushed = true
        uploadVC.modalPresentationStyle = .overFullScreen
        self.present(uploadVC, animated: true)
    }
    
}

extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        if indexPath.row < DataManager.shared.postList.count {
            let post = DataManager.shared.postList[indexPath.row]
            cell.setData(data: post)
        }
        //cell 선택시 선택효과 제거
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ViewController - tableView(didSelectRowAt) indexPath = \(indexPath)")
        let postDetailVC = self.storyboard?.instantiateViewController(identifier: "PostDetailViewController") as! PostDetailViewController
        postDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postDetailVC, animated: true)
        // postTableView.deselectRow(at: indexPath, animated: true) // cell 선택후 기본 상태로 바로 돌아가기
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
