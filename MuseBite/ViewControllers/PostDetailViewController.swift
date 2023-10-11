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

class PostDetailViewController: UIViewController {
    
    @IBOutlet var postDetailTableView: UITableView!
    @IBOutlet var commentTextField: UITextField!
    
    
    var postID: String = ""
    var postData: PostModel? = nil
    var comments:[CommentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        fetchRecentCommentData()
    }
    
    func initUI() {
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
        let postDetailTableViewCell = UINib(nibName: "PostDetailTableViewCell", bundle: nil)
        postDetailTableView.register(postDetailTableViewCell, forCellReuseIdentifier: "PostDetailTableViewCell")
        let commentsTableViewCell = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        postDetailTableView.register(commentsTableViewCell, forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func uplaodCommentButtonClicked(_ sender: Any) {
        let comment = commentTextField.text!
        if comment == "" {
            return
        }
        uploadComment(comment: comment)
    }
    
    func setData(post: PostModel) {
        self.postData = post
        self.postID = post.postID
    }
    
    func reloadPage() {
        fetchPostData()
        fetchRecentCommentData()
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
    
    func fetchRecentCommentData() {
        print("PostDetailViewController - fetchRecentCommentData()")
        let commentQuery = Firestore.firestore().collection("comment").whereField("postID", isEqualTo: postID).order(by: "createdTime", descending: false)
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
            self.comments.removeAll()
            for document in documents {
                let comment = CommentModel(document: document)
                self.comments.append(comment)
            }
            self.postDetailTableView.reloadData()
        }
    }
    
    func uploadComment(comment: String) {
        let commentCollection = Firestore.firestore().collection("comment")
        var ref: DocumentReference? = nil
        ref = commentCollection.addDocument(data: [
            "content": comment,
            "createdTime": Timestamp(date: Date()),
            "userID": LoginManager.shared.getUserID(),
            "userNickName": LoginManager.shared.getUserNickName(),
            "postID": postID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.fetchRecentCommentData()
            }
        }
        
    }
    
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
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
            cell.setData(data: comments[indexPath.row - 1])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
