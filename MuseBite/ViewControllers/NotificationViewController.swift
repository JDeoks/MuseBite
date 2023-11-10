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
    
    let notificationViewModel = NotificationViewModel()
    
    let disposeBag = DisposeBag()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var notificationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bind()
        notificationViewModel.fetchNotificationsData()
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
    
    @objc func pullToRefresh(_ sender: Any) {
        notificationViewModel.fetchNotificationsData()
        refreshControl.endRefreshing()
    }
    
    func bind() {
        notificationViewModel.getPostByIdDone
            .subscribe { _ in
                let postDetailVC = self.storyboard?.instantiateViewController(identifier: "PostDetailViewController") as! PostDetailViewController
                postDetailVC.postDetailVM.setPostData(post: self.notificationViewModel.currentPost!)
                self.navigationController?.pushViewController(postDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        notificationViewModel.fetchNotificationsDataDone
            .subscribe { _ in
                self.notificationTableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        notificationViewModel.showDeletedPost
            .subscribe { _ in
                self.showDeletedPostAlert()
            }
            .disposed(by: disposeBag)
    }

}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoginManager.shared.getLoginStatus() == true {
            return notificationViewModel.notifications.count
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
        cell.setData(data: notificationViewModel.notifications[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationViewModel.getPostById(postId: notificationViewModel.notifications[indexPath.row].postID)
    }

}

