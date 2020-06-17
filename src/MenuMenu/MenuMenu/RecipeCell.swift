//
//  RecipeTableLowerTableCell.swift
//  MenuMenu
//
//  Created by refo on 2020/05/30.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeCellLabel: UILabel!
    @IBOutlet weak var recipeCellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
