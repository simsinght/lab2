//
//  PhotoViewCell.swift
//  Tumbler Feed
//
//  Created by Rajit Dang on 2/9/17.
//  Copyright © 2017 Rajit Dang. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
