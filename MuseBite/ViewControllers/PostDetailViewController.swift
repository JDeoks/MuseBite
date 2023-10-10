//
//  PostDetailViewController.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    @IBOutlet var postDetailTableView: UITableView!
    
    var post: PostModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
        let postDetailTableViewCell = UINib(nibName: "PostDetailTableViewCell", bundle: nil)
        postDetailTableView.register(postDetailTableViewCell, forCellReuseIdentifier: "PostDetailTableViewCell")
        let commentsTableViewCell = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        postDetailTableView.register(commentsTableViewCell, forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    func setData(post: PostModel) {
        self.post = post
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 글 표시
        if indexPath.row == 0 {
            let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as! PostDetailTableViewCell
            cell.setData(post: post!)
            //cell 선택시 선택효과 제거
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else { // 댓글 표시
            let cell = postDetailTableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
            //cell 선택시 선택효과 제거
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
