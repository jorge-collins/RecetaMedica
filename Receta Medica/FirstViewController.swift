//
//  FirstViewController.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 25/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirstViewController: UIViewController {

    private var backgroundTaskID : UIBackgroundTaskIdentifier!
    private var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser

        // Vigilamos la condicion para continuar, en caso contrario se realiza lo indicado en su "else"
        guard currentUser != nil else {
            self.performSegue(withIdentifier: "showUserNoLogged", sender: self)
            return
        }

        /// Perform the task on a background queue.
        DispatchQueue.global().async {
           // Request the task assertion and save the ID.
           self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Finish Network Tasks") {
              // End the task if time expires.
              UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
           }
        /// ... lo que encierra este comment es lo que debe de envolver la tarea que se quiera mandar a segundo plano
            
            // Recuperamos de la DB los datos del usuario autorizado
            DatabaseService.shared.userRef.observeSingleEvent(of: .value) { (snapshot) in
    //            print("snapshot: \(snapshot)")
                if let users = snapshot.value as? Dictionary<String, AnyObject> {
                    for (key, value) in users {
                        print("key: \(key)")
                        if currentUser?.uid == key {
                            if let profile = value as? Dictionary<String, AnyObject> {
    //                            print("profile: \(profile)")
                                if let dict = profile["profile"] as? Dictionary<String, AnyObject> {
    //                                print("dict: \(dict)")
                                    if let firstName = dict["firstName"] as? String, let lastName = dict["lastName"] as? String,
                                       let emailTo     = dict["email"] as? String,     let password = dict["password"] as? String {
                                        let userid = key
                                        // le asignamos los datos recuperados al usuario que se enviara en el segue
                                        self.user = User(userid: userid, email: emailTo, firstName: firstName, lastName: lastName, password: password)
                                        // Ejecutamos el segue
                                        self.performSegue(withIdentifier: "showUserLogged", sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
           
            /// End the task assertion.
           UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        /// ... Aqui cierras el DispatchQueue.
        
         print("Quedamos afuera del guard")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUserLogged" {
            print("in prepare for segue.identifier, user.userid: \(self.user.userid)")
            if let destinationVC = segue.destination as? MedsTableViewController {
                destinationVC.user = self.user
            }
        }
    }


}
