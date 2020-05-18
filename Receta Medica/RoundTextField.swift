//
//  RoundTextField.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 08/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit

@IBDesignable

class RoundTextField: UITextField {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = (cornerRadius > 0)
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    

}
