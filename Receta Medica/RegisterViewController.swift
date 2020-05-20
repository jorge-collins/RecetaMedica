//
//  RegisterViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 18/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true

    }
    

    // MARK: - Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func siginPressed(_ sender: UIButton) {
        
        // Hacer el procedimiento de registro sin login (lo comentado en AuthService)
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text, let pass = passwordTextField.text, (firstName.count > 0 && lastName.count > 0 && email.count > 0 && pass.count > 0) {

            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            AuthService.shared.signin(email: email, password: pass, firstName: firstName, lastName: lastName, onComplete: { (message, data) in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                guard message == nil else {
                    
                    let alert = UIAlertController(title: "Hubo un problema", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                let alert = UIAlertController(title: "¡Hola \(firstName)!", message: "Has creado tu cuenta con exito", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    
                    self.dismiss(animated: true, completion: nil)

                }))
                self.present(alert, animated: true)
                
            })
            
            
        } else {
            let alert = UIAlertController(title: "Datos imcompletos", message: "Por favor completa todos los campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func alreadyPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
