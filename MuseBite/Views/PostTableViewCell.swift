//
//  PostTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    var post: PostModel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var userNickNameLabel: UILabel!
    @IBOutlet var createdTimeLabel: UILabel!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var dislikeCountLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: PostModel) {
        titleLabel.text = data.title
        descLabel.text = data.desc
        createdTimeLabel.text = data.getCreateTimeStr()
        userNickNameLabel.text = data.userNickName
    }
    
}
