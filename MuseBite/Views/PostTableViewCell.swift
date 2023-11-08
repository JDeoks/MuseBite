//
//  PostTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var userNickNameLabel: UILabel!
    @IBOutlet var createdTimeLabel: UILabel!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var dislikeCountLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    @IBOutlet var menuButton: UIButton!
    
    var postUserID: String?
    
    var myPostMenuItems: [UIAction] = {
        return [
            UIAction(title: "신고", image: UIImage(systemName: "exclamationmark.triangle.fill"), handler: { _ in }),
        ]
    }()
    
    lazy var myPostMenu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    var menuItems: [UIAction] = {
        return [
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in }),
        ]
    }()
    
    lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: myPostMenuItems)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initUI() {
//        if postUserID == LoginManager.shared.getUserID() {
//            print(postUserID, LoginManager.shared.getUserID())
//            print("아이디 같음")
//            menuButton.menu = myPostMenu
//        } else {
//            print(postUserID, LoginManager.shared.getUserID())
//            print("아이디 다름")
//            menuButton.menu = menu
//        }
//        menuButton.showsMenuAsPrimaryAction = true
    }
    
    func setData(data: PostModel) {
        postUserID = data.userID
        titleLabel.text = data.title
        descLabel.text = data.desc
        createdTimeLabel.text = data.getCreateTimeStr()
        userNickNameLabel.text = data.userNickName
        
        // 여기서 버튼 유형 결정
        if postUserID == LoginManager.shared.getUserID() {
            print(postUserID, LoginManager.shared.getUserID())
            print("아이디 같음")
            menuButton.menu = myPostMenu
        } else {
            print(postUserID, LoginManager.shared.getUserID())
            print("아이디 다름")
            menuButton.menu = menu
        }
        menuButton.showsMenuAsPrimaryAction = true
    }
    
}
