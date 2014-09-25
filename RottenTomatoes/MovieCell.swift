//
//  MovieCell.swift
//  RottenTomatoes
//
//  Created by Wanda Cheung on 9/23/14.
//  Copyright (c) 2014 Wanda Cheung. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var posterView: UIImageView!
  @IBOutlet weak var ratingLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
