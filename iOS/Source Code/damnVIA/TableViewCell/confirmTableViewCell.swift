//
//  confirmTableViewCell.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class confirmTableViewCell: UITableViewCell {

    @IBOutlet weak var fromAccountNumber: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var beneficiaryAccountNumber: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var beneficiaryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
