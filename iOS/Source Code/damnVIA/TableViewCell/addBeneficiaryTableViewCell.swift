//
//  addBeneficiaryTableViewCell.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 19/07/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit

class addBeneficiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var benfAccNoTF: UITextField!
    @IBOutlet weak var reEnterBenfAccNoTF: UITextField!
    @IBOutlet weak var aliasTF: UITextField!
    @IBOutlet weak var ifscCodeTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
