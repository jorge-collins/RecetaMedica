//
//  Parsing.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 05/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import Foundation
import UserNotifications

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
    
    


    func setLocalNotification(date: Date, title: String, subtitle: String, body: String, badge: NSNumber) -> String {
        var result = ""

//        print("date: \(date)")
        
        // 1 Obtenemos los componentes de la fecha recibida
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        var matchComponents = DateComponents()
        matchComponents.year = components.year
        matchComponents.month = components.month
        matchComponents.day = components.day
        matchComponents.hour = components.hour
        matchComponents.minute = components.minute
//        print("-- dateComponents: \(matchComponents)")
        
        // 1.5 Especificamos el trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: matchComponents, repeats: false)

        // 2 Especificamos el content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        content.sound = UNNotificationSound.default
        

        // 2.5 Configuramos el request de la notificación con un identificador aleatorio
        let randomIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

        // 3 Agregamos la notificacion
        UNUserNotificationCenter.current().add(request) { error in
          if error != nil {
            result = error!.localizedDescription
//            print("result: \(result)")
          }
        }

        return result
    }

    
    /**
        A partir de un valor en horas(time) devuelve su representacion en fracciones.
     
        El resultado siempre se entrega en `UTC`
        - Parameter time: la hora a traducir
        - Parameter format: formato en el que debe ser entregado el resultado
        
        - Returns: string indicando las horas (y/o minutos) en fracciones de hora
    */
    func timeAsFraction(time: String, format: String) -> String {
        var result = ""
//        print("time: \(time)")
        
        let timeAsDate = stringToDate(string: time, dateFormat: format)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: timeAsDate)
        
        if let hour = components.hour, let minute = components.minute {
            var fraction = ""
            switch minute {
                case 15:
                    fraction = "1/4"
                case 30:
                    fraction = "1/2"
                case 45:
                    fraction = "3/4"
                default:
                    fraction = ""
                }
                                    
            if hour == 0 {
                switch fraction {
                case "1/4", "3/4":
                    result = "\(fraction) de hora"
                case "1/2":
                    result = "\(fraction) hora"
                default:
                    break
                }
            } else {
                if fraction != "" {
                    result = "\(hour) \(fraction) horas"
                } else {
                    result = "\(hour) horas"
                }
            }

        }
        
        return result
    }
    
    
}

