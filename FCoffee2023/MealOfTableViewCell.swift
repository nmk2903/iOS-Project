//
//  MealOfTableViewCell.swift
//  FCoffee2023
//
//  Created by Koii on 6/1/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class MealOfTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMealPrice: UITextField!
    @IBOutlet weak var lblMealName: UITextField!
    @IBOutlet weak var imgMeal: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
