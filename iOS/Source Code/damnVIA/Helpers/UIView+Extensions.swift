//
//  UIView+Extensions.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 08/01/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func slideToRight(duration: TimeInterval = 0.5, completionDelegate: CAAnimationDelegate? = nil) {
        // Create a CATransition animation
        let slideTransition = CATransition()
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: CAAnimationDelegate = completionDelegate {
            slideTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideTransition.type = CATransitionType.push
        slideTransition.subtype = CATransitionSubtype.fromRight
        slideTransition.duration = duration
        slideTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        slideTransition.fillMode = CAMediaTimingFillMode.removed
        
        // Add the animation to the View's layer
        self.layer.add(slideTransition, forKey: "slideInFromRightTransition")
    }
    
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        layer.add(animation, forKey: "cornerRadius")
        layer.cornerRadius = to
    }
}

extension UILabel {
    
    func makeLoadingAnimation(timer: inout Timer, text: String) {
        self.text = "\(text) ."
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.30, repeats: true) { (timer) in
            var string: String {
                switch self.text {
                case "\(text) .":       return "\(text) .."
                case "\(text) ..":      return "\(text) ..."
                case "\(text) ...":     return "\(text) ...."
                case "\(text) ....":     return "\(text) ....."
                case "\(text) .....":     return "\(text) ."
                default:                return "\(text)"
                }
            }   
            self.text = string
        }
    }
    
    func stopLoadingAnimation(timer: inout Timer) {
        //Stop the timer
        timer.invalidate()
    }
}

