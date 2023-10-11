//
//  PostDetailTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var createdTimeLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(post: PostModel) {
        titleLabel.text = post.title
        nickNameLabel.text = post.userNickName
        createdTimeLabel.text = post.getCreateTimeStr()
        descLabel.text = post.desc
    }
}
