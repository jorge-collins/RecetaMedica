//
//  ViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 17/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
       
    private var userID = String()
    private var user : User!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        /// Inicializaciones para testing
        emailTextField.text = "jorge.collins@corosoftware.com"
        passwordTextField.text = "collins"
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
        print("Aqui hacemos el procedimiento para recuperar el password")
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        // Si ambos campos tienen contenido
        if let email = self.emailTextField.text, let pass = self.passwordTextField.text, (email.count > 0 && pass.count > 0) {
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            AuthService.shared.login(email: email, password: pass, onComplete: { (message, data) in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                guard message == nil else {
                    
                    let alert = UIAlertController(title: "Hubo un error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                
                /// "Popup" de bienvenida
                let alert = UIAlertController(title: "¡Bienvenido!", message: "\(email)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    // Aqui se le manda la info al siguiente view despues de consultar en la DB
                    DatabaseService.shared.userRef.observeSingleEvent(of: .value) { (snapshot) in
//                        print("snapshot: \(snapshot)")
                        if let users = snapshot.value as? Dictionary<String, AnyObject> {
                            for (key, value) in users {
//                                print("key: \(key)")
                                if let profile = value as? Dictionary<String, AnyObject> {
//                                    print("profile: \(profile)")
                                    if let dict = profile["profile"] as? Dictionary<String, AnyObject> {
//                                        print("dict: \(dict)")
                                        if let firstName = dict["firstName"] as? String, let lastName = dict["lastName"] as? String,
                                           let email     = dict["email"] as? String,     let password = dict["password"] as? String {
                                            
                                            let userid = key
                                            let user = User(userid: userid, email: email, firstName: firstName, lastName: lastName, password: password)
//                                            print("--- user: \(user)")
                                            self.userID = user.userid
                                            self.user = user
                                            self.performSegue(withIdentifier: "showMedsViewController", sender: self)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }))
                self.present(alert, animated: true)
            })
        } else {
            let alert = UIAlertController(title: "Usuario y/o contraseña incorrectos", message: "Por favor verifica los datos de acceso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(segue.destination.title)
        
        if segue.identifier == "showMedsViewController" {
//            print("in prepare for segue.identifier, userID: \(userID)")
            if let destinationVC = segue.destination as? MedsTableViewController {
//                print("in prepare for segue")
                destinationVC.userID = self.userID
                print("destinationVC.userID: \(destinationVC.userID)")
            }
        }
    }
    
}

