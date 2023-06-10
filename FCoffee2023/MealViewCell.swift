//
//  MealViewCell.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var lblMealPrice: UILabel!
    @IBOutlet weak var lblMealName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
