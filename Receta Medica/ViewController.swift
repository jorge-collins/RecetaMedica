//
//  ViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 17/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
       
    private var user : User!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        
        /// Inicializaciones para testing
        // 480uMmolZ5duweP0824wMIVKfxh1 : "USER" con 3 meds
        emailTextField.text = "user_testpwd@corosoftware.com"
        passwordTextField.text = "testpwd"
//        // 887zsjnW8paUo9GFmdH5g4TtXAB3 : "John" con 3 meds
//        emailTextField.text = "j_collins@gmail.com"
//        passwordTextField.text = "collins"
//        // SaRfcJGmOfXio1BmIxPvAco6oXz2 : "Jorge" con 2 meds
//        emailTextField.text = "user2_passwd2@corosoftware.com"
//        passwordTextField.text = "passwd2"
        // KiTn6dCxO8QbHz9VAPUkgWf9KNe2 : "J" con 0 meds
//        emailTextField.text = "user.passw0rd@corosoftware.com"
//        passwordTextField.text = "passw0rd"
        
        // Local Notification
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat2"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        // Local Notification EOF
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
                
                guard message == nil else {
                    
                    let alert = UIAlertController(title: "Hubo un problema", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    return
                }

                // Recuperamos de la DB los datos del usuario autorizado
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
                                       let emailTo     = dict["email"] as? String,     let password = dict["password"] as? String {
                                        
                                        // Si el "email" con el que se ingreso es el mismo que el que se esta consultando (emailTo)...
                                        if email == emailTo {
                                            
                                            let userid = key
                                            // le asignamos los datos recuperados al usuario que se enviara en el segue
                                            self.user = User(userid: userid, email: emailTo, firstName: firstName, lastName: lastName, password: password)
                                            // Restablecemos los elementos de la vista
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                            self.passwordTextField.text = ""
                                            // Ejecutamos el segue
                                            self.performSegue(withIdentifier: "showMedsViewController", sender: self)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            
            })
        } else {
            let alert = UIAlertController(title: "Datos incompletos", message: "Por favor ingrresa tu correo y contraseña.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMedsViewController" {
//            print("in prepare for segue.identifier, userID: \(userID)")
            if let destinationVC = segue.destination as? MedsTableViewController {
                destinationVC.user = self.user
            }
        }
    }
    
}

