//
//  accountStatementTableViewCell.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class accountStatementTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var refNumber: UILabel!
    @IBOutlet weak var narration: UILabel!
    @IBOutlet weak var valueDate: UILabel!
    @IBOutlet weak var closingBalance: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
