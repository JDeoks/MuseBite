//
//  NotificationViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/14.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import SwiftDate
import RxSwift

class NotificationViewController: UIViewController {
    
    var notifications: [NotificationModel] = []
    
    let notificationViewModel = NotificationViewModel()
    let disposeBag = DisposeBag()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        fetchNotificationsData()
    }
    
    func initUI() {
        // refreshControl
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        // postTableView
        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        let notificationTableViewCell = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        notificationTableView.register(notificationTableViewCell, forCellReuseIdentifier: "NotificationTableViewCell")
        let notificationNonLoginTableViewCell = UINib(nibName: "NotificationNonLoginTableViewCell", bundle: nil)
        notificationTableView.register(notificationNonLoginTableViewCell, forCellReuseIdentifier: "NotificationNonLoginTableViewCell")
        notificationTableView.refreshControl = refreshControl
        // 네비게이션
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bind() {
        notificationViewModel.getPostByIdDone
            .subscribe { _ in
                let postDetailVC = self.storyboard?.instantiateViewController(identifier: "PostDetailViewController") as! PostDetailViewController
                postDetailVC.postDetailVM.setPostData(post: self.notificationViewModel.currentPost!)
                self.navigationController?.pushViewController(postDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        fetchNotificationsData()
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        self.notificationTableView.reloadData()
    }

    func fetchNotificationsData() {
        print("DataManager - fetchNotificationsData()")
        
        let userID = LoginManager.shared.getUserID()
        let commentQuery = Firestore.firestore().collection("notification").whereField("userID", isEqualTo: userID).order(by: "createdTime", descending: true)
        commentQuery.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                // 에러 처리: 사용자에게 메시지 표시 또는 기록
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }
            self.notifications.removeAll()
            for document in documents {
                let noti = NotificationModel(document: document)
                self.notifications.append(noti)
            }
            self.notificationTableView.reloadData()
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoginManager.shared.getLoginStatus() == true {
            return notifications.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if LoginManager.shared.getLoginStatus() == false {
            let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationNonLoginTableViewCell") as! NotificationNonLoginTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.setData(data: notifications[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationViewModel.getPostById(postId: notifications[indexPath.row].postID)
    }

}

