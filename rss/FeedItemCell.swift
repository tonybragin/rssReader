//
//  FeedItemCell.swift
//  rss
//
//  Created by TONY on 19/04/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {

    @IBOutlet weak var nameItemLabel: UILabel!
    @IBOutlet weak var infoItemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
