//
//  UIView.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 02/05/2017.
//  Copyright © 2017 MARQUET. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func shake(){
        let start = CGPoint(x:self.center.x-10, y:self.center.y)
        let end = CGPoint(x:self.center.x+10, y:self.center.y)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.5
        animation.repeatCount = 300
        animation.autoreverses = true
        animation.fromValue = start
        animation.toValue = end
        self.layer.add(animation, forKey: "position")

    }
}
