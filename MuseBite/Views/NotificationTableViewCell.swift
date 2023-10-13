//
//  NotificationTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/14.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var createdTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: NotificationModel) {
        titleLabel.text = data.title
        commentLabel.text = "\(data.commentUserNickName)님의 댓글이 달렸어요:\n\(data.comment)"
        createdTimeLabel.text = data.getCreateTimeStr()
    }
}
