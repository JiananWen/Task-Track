//
//  HistoryTableViewCell.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/15/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var progressview: UIView!
    
    @IBOutlet weak var historyDateLabel: UILabel!
    
    
    @IBOutlet var bartrailing: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
