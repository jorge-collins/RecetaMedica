//
//  User.swift
//  Receta Medica
//
//  Created by Jorge Collins Gómez on 19/05/20.
//  Copyright © 2020 Jorge Collins Gómez. All rights reserved.
//

import Foundation

struct User {
    private var _userid: String
    private var _email: String
    private var _firstName: String
    private var _lastName: String
    private var _password: String
    
    var userid: String { return _userid }
    var email: String { return _email }
    var firstName: String { return _firstName }
    var lastName: String { return _lastName }
    var password: String { return _password }
    
    init(userid: String, email: String, firstName: String, lastName: String, password: String) {
        self._userid = userid
        self._email = email
        self._firstName = firstName
        self._lastName = lastName
        self._password = password
    }

}
