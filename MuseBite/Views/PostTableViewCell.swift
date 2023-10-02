//
//  PostTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 2023/10/02.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height += 12 // 위아래로 6포인트씩 간격을 추가합니다.
            return sizeThatFits
    }
}
