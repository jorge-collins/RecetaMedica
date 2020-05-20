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
    
    
    // Registro de cuenta del usuario
    func signin (email : String, password: String, firstName: String, lastName: String, onComplete: Completion?) {
        // Aqui hacemos el registro de la cuenta
        // Intentamos crear el usuario
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // Si existe error al crear al usuario
            if let error = (error as NSError?) {
                // Mostrar el error al usuario
                self.handleFirebaseError(error: error, onComplete: onComplete)
            } else {
                // Comprobamos que se haya creado el usuario
                if user?.user.uid != nil {

                    // Guardamos el usuario en la DB
                    DatabaseService.shared.saveUser(uid: (user?.user.uid)!, email: email, password: password, firstName: firstName, lastName: lastName)

                    onComplete?(nil, user!)
                }
            }
        }
    }
    
    // Inicio de sesion del usuario
    func login (email : String, password : String, onComplete : Completion?) {
        // Aqui haremos el login
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // Comprobamos si ha habido un error
            if let error = (error as NSError?) {
                // Revisamos cual codigo de error es
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    
                    print(">> errorCode: \(errorCode.rawValue)")
                    self.handleFirebaseError(error: error, onComplete: onComplete)
                }
            } else {
                // No hubo error, hay que presentar el siguiente ViewController
                onComplete?(nil, user!)
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print("--Error: \(error.debugDescription)")
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
                // Dependiendo del error devuelto por Firebase, es la leyenda que se muestra
                case .invalidEmail, .wrongPassword, .invalidCredential, .accountExistsWithDifferentCredential:
                    onComplete?("Correo y/o contraseña incorrectos, favor de verificar los datos.", nil)
                    break
                case .userDisabled:
                    onComplete?("Este usuario se encuentra deshabilitado.", nil)
                    break
                case .emailAlreadyInUse:
                    onComplete?("No se ha podido crear la cuenta ya que este correo ya se encuentra registrado.", nil)
                    break
                case .weakPassword:
                    onComplete?("Contraseña demasiado débil.", nil)
                    break
                case .userNotFound:
                    onComplete?("El usuario no existe, por favor crea una cuenta.", nil)
                    break
                default:
                    onComplete?("Hubo un error al iniciar sesión, intenta nuevamente.", nil)
                    break
            }
        }
    }
    
}
