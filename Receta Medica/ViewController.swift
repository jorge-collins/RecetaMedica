//
//  ViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 17/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoImage.layer.cornerRadius = 50.0
        logoImage.clipsToBounds = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

