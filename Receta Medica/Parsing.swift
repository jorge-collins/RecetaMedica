//
//  Parsing.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 05/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import Foundation

class Parsing {
    
    private static let _shared = Parsing()
    
    static var shared : Parsing {
        return _shared
    }
    
    /**
        Convierte un string a un valor tipo `date`.
     
        El resultado siempre se entrega en `UTC`
        - Parameter string: cadena que contiene la fecha
        - Parameter dateFormat: formato en el que debe ser leida la fecha ingresada
        
        - Returns: valor tipo `date`
    */
    func stringToDate(string: String, dateFormat: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string) ?? Date()
        
        return date
    }
    
    /**
        Convierte en cadena un valor tipo `date`.
     
        El resultado siempre se entrega en `UTC`
        - Parameter date: la fecha a convertir
        - Parameter localeId: el identificador de zona horaria
        - Parameter dateFormat: formato en el que debe ser entregada la fecha
        
        - Returns: fecha `date` en string
    */
    func dateToString(date: Date, localeId: String, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: localeId)
        formatter.dateFormat = dateFormat
        let str = formatter.string(from: date)
        
        return str
    }
    
    /*
    //    @IBAction func quantityStepper(_ sender: UIStepper) {
    //        quantityVar = sender.value * 0.25
    //        let integer = Int(quantityVar)
    //        let minus = quantityVar - Double(integer)
    //        var fraction = ""
    //        switch minus {
    //        case 0.25:
    //            fraction = "1/4"
    //        case 0.5:
    //            fraction = "1/2"
    //        case 0.75:
    //            fraction = "3/4"
    //        default:
    //            fraction = ""
    //        }
    //        var result = "\(fraction)"
    //        if integer > 0 {
    //            result = "\(integer) \(fraction)"
    //        }
    //
    //        quantityTextField.text = String(result)
    //    }
    */
}

