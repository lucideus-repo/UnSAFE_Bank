//
//  BankTransferVC7.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 05/04/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit
import Lottie

class BankTransferVC7: UIViewController {

    @IBOutlet weak var atv: AnimationView!
    var refNo: String!
    
    @IBAction func donePressed(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
    }
    
    @IBOutlet weak var refLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let tickAnimation = Animation.named("tick1", bundle: Bundle.main, subdirectory: nil, animationCache: nil)
        atv.animation = tickAnimation
        atv.contentMode = .scaleAspectFit
        atv.play()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refLabel.text = "Transaction Reference: " + refNo
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
