//
//  ViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 17/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
}

