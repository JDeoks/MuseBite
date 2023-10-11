//
//  CommentsTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/03.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var userNickNameLabel: UILabel!
    @IBOutlet var createdTimeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: CommentModel) {
        contentLabel.text = data.content
        userNickNameLabel.text = data.userNickName
        createdTimeLabel.text = data.getCreateTimeStr()
//        titleLabel.text = data.title
//        descLabel.text = data.desc
//        creationTimeLabel.text = data.getCreateTimeStr()
//        userNickNameLabel.text = data.userNickName
    }
    
}
