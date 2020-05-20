//
//  DatabaseService.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 29/04/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

let FIR_CHD_USERS = "users"
let FIR_CHD_MEDS = "meds"

import Foundation
import FirebaseDatabase

class DatabaseService {
    
    private static let _shared = DatabaseService()
    
    static var shared : DatabaseService {
        return _shared
    }
    
    var mainRef : DatabaseReference {
        return Database.database().reference()
    }
    
    var medsRef : DatabaseReference {
        return mainRef.child(FIR_CHD_MEDS)
    }
    
    var userRef : DatabaseReference {
        return mainRef.child(FIR_CHD_USERS)
    }
    
    func saveUser(uid: String, email: String, password: String, firstName: String, lastName: String) {
        let profile : Dictionary<String, AnyObject> = [
            "email": email as AnyObject,
            "password": password as AnyObject,
            "firstName": firstName as AnyObject,
            "lastName": lastName as AnyObject]
        
        self.mainRef.child(FIR_CHD_USERS).child(uid).setValue(profile)
    }
        
    func saveMed(userUID: String, type: String, quantity: String, periodicityInHours: String, name: String, mediaURL: String, firstDose: String, daysToTake: String, alerts: Dictionary<String, AnyObject>) {
        
        var dates = Dictionary<String, Bool>()
        
        for alert in alerts.keys {
            dates[alert] = true
        }
        
        let med : Dictionary<String, AnyObject> = [
            "alerts": dates as AnyObject,
            "daysToTake": daysToTake as AnyObject,
            "firstDose": firstDose as AnyObject,
            "mediaURL": mediaURL as AnyObject,
            "name": name as AnyObject,
            "periodicityInHours": periodicityInHours as AnyObject,
            "quantity": quantity as AnyObject,
            "type": type as AnyObject,
            "userid": userUID as AnyObject
        ]
        
        self.medsRef.childByAutoId().setValue(med)
    }
    
    func deleteMed(medid: String) {
        self.medsRef.child(medid).removeValue()
    }
}
