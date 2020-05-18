//
//  RoundImage.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 18/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit

@IBDesignable

class RoundImage: UIImageView {
    
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
