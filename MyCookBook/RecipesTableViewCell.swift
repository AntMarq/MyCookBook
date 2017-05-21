//
//  RecipesTableViewCell.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 17/01/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var resume: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
