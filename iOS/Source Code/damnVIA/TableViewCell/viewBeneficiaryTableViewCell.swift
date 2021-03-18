//
//  viewBeneficiaryTableViewCell.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class viewBeneficiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNumber: UILabel! //acc number
    @IBOutlet weak var accountType: UILabel! // date -> temporary fix
    @IBOutlet weak var ifscCode: UILabel! //ifsc code
    @IBOutlet weak var beneficiaryName: UILabel! //alias
    @IBOutlet weak var email: UILabel! //email
  //  @IBOutlet weak var date: UILabel! //temporary fix
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
