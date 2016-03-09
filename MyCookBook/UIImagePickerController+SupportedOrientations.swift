//
//  UIImagePickerController+SupportedOrientations.swift
//  MyCookBook
//
//  Created by Anthony MARQUET on 06/03/2016.
//  Copyright © 2016 MARQUET. All rights reserved.
//

import Foundation
import UIKit

extension UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
}
