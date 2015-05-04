//
//  PostTableViewCell.swift
//  TheCodingLove
//
//  Created by Rafael Almeida on 01/05/15.
//  Copyright (c) 2015 Rafael Almeida. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postAuthorLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
