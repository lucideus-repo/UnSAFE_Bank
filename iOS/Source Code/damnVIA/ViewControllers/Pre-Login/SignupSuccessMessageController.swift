//
//  SignupSuccessMessageController.swift
//  damnVIA
//
//  Created by ECS iOS Practice on 02/03/20.
//  Copyright © 2020 lucideus. All rights reserved.
//

import UIKit
import Lottie

class SignupSuccessMessageController: UIViewController {
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var customerIDTextView: UITextView!
    @IBOutlet weak var importantMessageLabel: UILabel!
    
    var customerID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tickAnimation = Animation.named("tick1", bundle: Bundle.main, subdirectory: nil, animationCache: nil)
        animationView.animation = tickAnimation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        customerIDTextView.text = customerID
        //successLabel.text = "Thank you for choosing UnSAFE Bank, use below customer id for login"
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        if let id = customerID {
           UIPasteboard.general.string = id
        }
       
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
