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
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var postDetailTableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    
    var postID: String = ""
    var postData: PostModel? = nil
//    var comments: [CommentModel] = []
    
    let postDetailVM = PostDetailViewModel()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bind()
        postDetailVM.fetchRecentCommentData(postID: postID)
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
    
    /// 뷰모델의 옵저버블을 구독
    func bind() {
        postDetailVM.fetchCommentDone
            .subscribe(onNext: { _ in
                self.postDetailTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func uplaodCommentButtonClicked(_ sender: Any) {
        if LoginManager.shared.getLoginStatus() == false {
            showLoginRequiredAlert()
            return
        }
        if let comment = commentTextField.text {
            if comment == "" { return }
            postDetailVM.uploadComment(comment: comment, postID: postID)
            registerNotification(comment: comment)
        }
        commentTextField.text = ""
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        reloadPage()
        refreshControl.endRefreshing()
    }
    
    func setData(post: PostModel) {
        self.postData = post
        self.postID = post.postID
    }
    
    func reloadPage() {
        fetchPostData()
        postDetailVM.fetchRecentCommentData(postID: postID)
    }
    
    func fetchPostData() {
        print("PostDetailViewController - fetchPostData()")
        let postDoc = Firestore.firestore().collection("post").document(postID)
        postDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let post = PostModel(document: document)
                self.setData(post: post)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func registerNotification(comment: String) {
        let notiCollection = Firestore.firestore().collection("notification")
        var ref: DocumentReference? = nil
        ref = notiCollection.addDocument(data: [
            "createdTime": Timestamp(date: Date()),
            "userID": postData?.userID,
            "postID": postID,
            "title": postData!.title,
            "comment": comment,
            "commentUserNickName": LoginManager.shared.getUserNickName()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.postDetailVM.fetchRecentCommentData(postID: self.postID)
            }
        }
    }
    
    func showLoginRequiredAlert () {
        let sheet = UIAlertController(title: "로그인 후 이용 가능한 서비스입니다.", message: "로그인으로 더 많은 서비스를 사용해보세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "로그인", style: .default, handler: { _ in
            print("yes 클릭")
            let LogInVC = self.storyboard?.instantiateViewController(identifier: "LogInViewController") as! LogInViewController
            LogInVC.modalPresentationStyle = .overFullScreen
            self.present(LogInVC, animated: true)
            return
        }))
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel ))
        present(sheet, animated: true)
    }
    
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetailVM.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 글 표시
        if indexPath.row == 0 {
            let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as! PostDetailTableViewCell
            cell.setData(post: postData!)
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
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
