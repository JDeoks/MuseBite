//
//  PostDetailViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics
import RxSwift

class PostDetailViewController: UIViewController {
    
    let postDetailVM = PostDetailViewModel()
    var postID: String = ""
    let refreshControl = UIRefreshControl()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var postDetailTableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        postDetailVM.fetchRecentCommentData()
    }
    
    func initUI() {
        // postDetailTableView
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
        let postDetailTableViewCell = UINib(nibName: "PostDetailTableViewCell", bundle: nil)
        postDetailTableView.register(postDetailTableViewCell, forCellReuseIdentifier: "PostDetailTableViewCell")
        let commentsTableViewCell = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        postDetailTableView.register(commentsTableViewCell, forCellReuseIdentifier: "CommentsTableViewCell")
        postDetailTableView.refreshControl = refreshControl
        // refreshControl
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    func action() {
        backButton.rx.tap
            .subscribe { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .subscribe { _ in
                if let comment = self.commentTextField.text {
                    self.postDetailVM.uploadComment(comment: comment)
                }
                self.commentTextField.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    /// 뷰모델의 옵저버블을 구독
    func bind() {
        postDetailVM.fetchPostDataDone
            .subscribe(onNext: { _ in
                self.postDetailTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        postDetailVM.fetchRecentCommentDataDone
            .subscribe(onNext: { _ in
                self.postDetailTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        postDetailVM.showLoginRequired
            .subscribe { _ in
                self.showLoginRequiredAlert()
            }
            .disposed(by: disposeBag)
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        reloadPage()
        refreshControl.endRefreshing()
    }
    
    func reloadPage() {
        postDetailVM.fetchPostData()
        postDetailVM.fetchRecentCommentData()
    }

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // index 0은 post
        return postDetailVM.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 글 표시
        if indexPath.row == 0 {
            let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as! PostDetailTableViewCell
            cell.setData(post: postDetailVM.postData!)
            //cell 선택시 선택효과 제거
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else { // 댓글 표시
            let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
            cell.setData(data: postDetailVM.comments[indexPath.row - 1])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
}
