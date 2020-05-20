//
//  AuthService.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 28/04/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errorMessage: String?,_ data: AnyObject?) -> Void

class AuthService {
    
    private static let _shared = AuthService()
    
    static var shared : AuthService {
        return _shared
    }
    
    /*
    func signin(firstName: String, lastName: String, email: String, password: String, onComplete: Completion?) {
        // Intentamos crear el usuario
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // Si existe error al crear al usuario
            if let error = (error as NSError?) {
                // Mostrar el error al usuario
                self.handleFirebaseError(error: error, onComplete: onComplete)
            } else {
                // Comprobamos que se haya creado el usuario
                if user?.user.uid != nil {
                    
                    // Guardamos el usuario
                    DatabaseService.shared.saveUser(uid: (user?.user.uid)!, email: email, password: password, firstName: "John", lastName: "Doe")
                    
                    // Entonces intentamos hacer login
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        // Si existe algun error (no deberia ya que para llegar aqui el usuario no existia)
                        if let error = (error as NSError?) {
                            // Mostrar el error al usuario
                            self.handleFirebaseError(error: error, onComplete: onComplete)
                        } else {
                            // El login ha sido realizado con exito
                            onComplete?(nil, user!)
                        }
                    }
                }
            }
        }
    }
    */
    
    func login (email : String, password : String, onComplete : Completion?) {
        // Aqui haremos el login
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // Comprobamos si ha habido un error
            if let error = (error as NSError?) {
                // Revisamos cual codigo de error es
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    print(">> errorCode: \(error.description)")
                    
                    
                    
                    // Comprobamos que el error sea que no existe el usuario
//                    if errorCode == AuthErrorCode.userNotFound {
                        
                        
                        
//                        // Intentamos crear el usuario
//                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                            // Si existe error al crear al usuario
//                            if let error = (error as NSError?) {
//                                // Mostrar el error al usuario
//                                self.handleFirebaseError(error: error, onComplete: onComplete)
//                            } else {
//                                // Comprobamos que se haya creado el usuario
//                                if user?.user.uid != nil {
//
//                                    // Guardamos el usuario
//                                    DatabaseService.shared.saveUser(uid: (user?.user.uid)!, email: email, password: password, firstName: "John", lastName: "Doe")
//
//                                    // Entonces intentamos hacer login
//                                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//                                        // Si existe algun error (no deberia ya que para llegar aqui el usuario no existia)
//                                        if let error = (error as NSError?) {
//                                            // Mostrar el error al usuario
//                                            self.handleFirebaseError(error: error, onComplete: onComplete)
//                                        } else {
//                                            // El login ha sido realizado con exito
//                                            onComplete?(nil, user!)
//                                        }
//                                    }
//                                }
//                            }
//                        }
                        
                        
                        
//                    } else {
                        // No es ese tipo de error, revisamos cual es entonces
                        self.handleFirebaseError(error: error, onComplete: onComplete)
//                    }
                }
            } else {
                // No hubo error, hay que presentar el siguiente ViewController
                onComplete?(nil, user!)
            }
            // ...
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print("--Error: \(error.debugDescription)")
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
//            case .invalidEmail:
//                onComplete?("Email incorrecto", nil)
//                break
            case .invalidEmail, .wrongPassword, .invalidCredential, .accountExistsWithDifferentCredential:
                onComplete?("Credenciales incorrectas, por favor verifica tus datos.", nil)
                break
            case .userDisabled:
                onComplete?("Este usuario se encuentra deshabilitado", nil)
                break
            case .emailAlreadyInUse:
                onComplete?("No se ha podido crear la cuenta ya que este email ya se encuentra registrado", nil)
                break
            case .weakPassword:
                onComplete?("Password demasiado débil", nil)
                break
            case .userNotFound:
                onComplete?("El usuario no existe, por favor crea una cuenta.", nil)
            default:
                onComplete?("Hubo un error al entrar, intenta nuevamente", nil)
                print("")
            }
        }
    }
    

}
