//
//  TableViewCell.swift
//  FCoffee2023
//
//  Created by Koii on 5/31/23.
//  Copyright © 2023 Nguyen Le Tam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var tableStatus: UILabel!
    @IBOutlet weak var tableStatusColor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
