//
//  RecordTableViewCell.swift
//  MuseBite
//
//  Created by 서정덕 on 11/5/23.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet var playStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playStackView.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
