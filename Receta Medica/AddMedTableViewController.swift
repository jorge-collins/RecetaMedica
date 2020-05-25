//
//  AddMedTableViewController.swift
//  Prescription Reminder (from)
//
//  Created by Jorge Collins Gómez on 02/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddMedTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    var quantityVar = 0.0
    @IBOutlet weak var quantityTextField: UITextField!
    
    var periodicityInHoursValueVar = ""
//    @IBOutlet weak var periodicityInHoursDatePicker: UIDatePicker!
    @IBOutlet weak var periodicityInHoursPicker: UIPickerView!

    let pickerData:[(myKey: String, myValue: String)] = [
        ("30 minutos", "00:30"), ("45 minutos", "00:45"),
        ("1 hora", "01:00"), ("1:15 horas", "01:15"), ("1:30 horas", "01:30"), ("1:45 horas", "01:45"),
        ("2 horas", "02:00"), ("2:15 horas", "02:15"), ("2:30 horas", "02:30"), ("2:45 horas", "02:45"),
        ("3 horas", "03:00"), ("3:15 horas", "03:15"), ("3:30 horas", "03:30"), ("3:45 horas", "03:45"),
        ("4 horas", "04:00"), ("4:15 horas", "04:15"), ("4:30 horas", "04:30"), ("4:45 horas", "04:45"),
        ("5 horas", "05:00"), ("5:15 horas", "05:15"), ("5:30 horas", "05:30"), ("5:45 horas", "05:45"),
        ("6 horas", "06:00"), ("6:15 horas", "06:15"), ("6:30 horas", "06:30"), ("6:45 horas", "06:45"),
        ("7 horas", "07:00"), ("7:15 horas", "07:15"), ("7:30 horas", "07:30"), ("7:45 horas", "07:45"),
        ("8 horas", "08:00"), ("8:15 horas", "08:15"), ("8:30 horas", "08:30"), ("8:45 horas", "08:45"),
        ("9 horas", "09:00"), ("9:15 horas", "09:15"), ("9:30 horas", "09:30"), ("9:45 horas", "09:45"),
        ("10 horas", "10:00"), ("10:15 horas", "10:15"), ("10:30 horas", "10:30"), ("10:45 horas", "10:45"),
        ("11 horas", "11:00"), ("11:15 horas", "11:15"), ("11:30 horas", "11:30"), ("11:45 horas", "11:45"),
        ("12 horas", "12:00"), ("12:15 horas", "12:15"), ("12:30 horas", "12:30"), ("12:45 horas", "12:45"),
        ("13 horas", "13:00"), ("13:15 horas", "13:15"), ("13:30 horas", "13:30"), ("13:45 horas", "13:45"),
        ("14 horas", "14:00"), ("14:15 horas", "14:15"), ("14:30 horas", "14:30"), ("14:45 horas", "14:45"),
        ("15 horas", "15:00"), ("15:15 horas", "15:15"), ("15:30 horas", "15:30"), ("15:45 horas", "15:45"),
        ("16 horas", "16:00"), ("16:15 horas", "16:15"), ("16:30 horas", "16:30"), ("16:45 horas", "16:45"),
        ("17 horas", "17:00"), ("17:15 horas", "17:15"), ("17:30 horas", "17:30"), ("17:45 horas", "17:45"),
        ("18 horas", "18:00"), ("18:15 horas", "18:15"), ("18:30 horas", "18:30"), ("18:45 horas", "18:45"),
        ("19 horas", "19:00"), ("19:15 horas", "19:15"), ("19:30 horas", "19:30"), ("19:45 horas", "19:45"),
        ("20 horas", "20:00"), ("20:15 horas", "20:15"), ("20:30 horas", "20:30"), ("20:45 horas", "20:45"),
        ("21 horas", "21:00"), ("21:15 horas", "21:15"), ("21:30 horas", "21:30"), ("21:45 horas", "21:45"),
        ("22 horas", "22:00"), ("22:15 horas", "22:15"), ("22:30 horas", "22:30"), ("22:45 horas", "22:45"),
        ("23 horas", "23:00"), ("23:15 horas", "23:15"), ("23:30 horas", "23:30"), ("23:45 horas", "23:45"),
        ("24 horas", "24:00")
    ]
    
    
    @IBOutlet weak var daysToTakeTextField: UITextField!
    
    var firstDoseValueVar = ""
    @IBOutlet weak var firstDoseDatePicker: UIDatePicker!

    @IBOutlet weak var iconImageView: UIImageView!
    
    var mediaURLVar = ""
    var typeVar = "5"
    let useridVar = Auth.auth().currentUser?.uid

//    var doseAlerts = [String]()
    var doseAlerts : Dictionary<String, AnyObject> = [:]
    let dateFormat = "yyyy-MM-dd HH:mmZ"

    // Esta variable, despues de agregar a la DB, se utiliza para poder actualizar el tableView padre
    var med : Med!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.periodicityInHoursPicker.delegate = self
        self.periodicityInHoursPicker.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
                
        periodicityInHoursPicker.selectRow(15, inComponent: 0, animated: true)
        periodicityInHoursValueVar = pickerData[15].myValue
        print("periodicityInHoursValueVar: \(periodicityInHoursValueVar)")

        daysToTakeTextField.isUserInteractionEnabled = false
        
        firstDoseValueVar = getValueDatePicker(dateFormat: dateFormat, datePicker: firstDoseDatePicker)

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Para deseleccionar el renglon de la tabla
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].myKey
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        periodicityInHoursValueVar = pickerData[row].myValue
    }
    
    
    
    @IBAction func daysToTakeStepper(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        daysToTakeTextField.text = String(quantity)
    }
    
    @IBAction func firstDoseDatePicker(_ sender: Any) {
        firstDoseValueVar = getValueDatePicker(dateFormat: dateFormat, datePicker: firstDoseDatePicker)
    }

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

        // Casting seguro para validar que no se queden en blanco los campos
        if let nameValue = self.nameTextField.text, let quantityValue = self.quantityTextField.text, let daysToTakeValue = self.daysToTakeTextField.text, (nameValue.count > 0 && quantityValue.count > 0) {

            let localeId = "es_ES"
            doseAlerts = [:]
            
            // Obtenemos las horas y minutos del periodo
            let periodicityHs = Int(periodicityInHoursValueVar.prefix(2))!
            let periodicityMs = Int(periodicityInHoursValueVar.suffix(2))!
            print("periodicityInHoursValueVar: \(periodicityInHoursValueVar)")
            print("periodicityHs: \(periodicityHs)")
            print("periodicityMs: \(periodicityMs)")

            
            // Obtenemos en tipo `date` la fecha inicial
            let firstDoseValueDate = Parsing.shared.stringToDate(string: firstDoseValueVar, dateFormat: dateFormat)
//            print("firstDoseValueDate: \(firstDoseValueDate)")
            
            // Obtenemos en `Int` el numero de dias del tratamiento a la fecha inicial
            let daysToTakeAsInt = Int(daysToTakeTextField.text!)!
            // Obtenemos en `date` la fecha final del tratamiento
            let lastDoseValueDate = Calendar.current.date(byAdding: .day, value: +daysToTakeAsInt, to: firstDoseValueDate)!
            
            // Inicializamos la variable para cada alerta
            var newAlert = firstDoseValueDate
            // Inicializamos la variable para comparar si ya se supero la fecha final del tratamiento
            var repeatOneMore = ComparisonResult.orderedAscending
            repeat {

                /// Agregar una LocalNotification
                // Obtenemos la forma como deseamos que se vea la hora
                let medTime = Parsing.shared.dateToString(date: newAlert, localeId: localeId, dateFormat: "H:mm")
                // Agregamos la notificación
                let notificationID = Parsing.shared.setLocalNotification(date: newAlert, title: "\(nameValue) - \(quantityValue)", subtitle: "", body: medTime, badge: 1)
                /// EOF
                
                // Convertimos la newAlert como tipo string
                let newAlertAsStr = Parsing.shared.dateToString(date: newAlert, localeId: localeId, dateFormat: dateFormat)
                // Agregar la newAlert al array de alertas
                doseAlerts[newAlertAsStr] = notificationID as AnyObject
//                doseAlerts[newAlertAsStr] = true as AnyObject
                                
                // Agregar las horas y minutos a la ultima fecha
                if periodicityHs > 0 {
                    newAlert = Calendar.current.date(byAdding: .hour, value: +periodicityHs, to: newAlert)!
                }
                if periodicityMs > 0 {
                    newAlert = Calendar.current.date(byAdding: .minute, value: +periodicityMs, to: newAlert)!
                }
                // Preguntamos si la newAlert es menor a la fecha final del tratamiento...
                repeatOneMore = Calendar.current.compare(newAlert, to: lastDoseValueDate, toGranularity: .minute)
              // ... sí lo es, repite
            } while repeatOneMore == ComparisonResult.orderedAscending
            // print("doseAlerts: \(doseAlerts)")
            
            // Agregamos el medicamento a la base de datos
            DatabaseService.shared.saveMed(userUID: useridVar!, type: typeVar, quantity: quantityValue, periodicityInHours: periodicityInHoursValueVar, name: nameValue, mediaURL: mediaURLVar, firstDose: firstDoseValueVar, daysToTake: daysToTakeValue, alerts: self.doseAlerts)

            // Agregamos el medicamento al array de medicamentos de la App
            self.med = Med(medid: "", userid: useridVar!, name: nameValue, type: typeVar, mediaURL: mediaURLVar, daysToTake: daysToTakeValue, firstDose: firstDoseValueVar, periodicityInHours: periodicityInHoursValueVar, quantity: quantityValue, alerts: self.doseAlerts)

            UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
                print(request)
            }
            // Realizamos el unwind para poder realizar operaciones en la vista anterior
            performSegue(withIdentifier: "unwindToMedsTableSegue", sender: self)

        } else {
            let alertController = UIAlertController(title: "Faltan datos", message: "Revisa que no existan campos vacios.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    
//    @IBAction func changeIconPressed(_ sender: Any) {
//        // Solo se utilizo para comprobar el botón pero no es necesario por el -segue-
//    }
    
    
     /// Al hacer un segue "present modally", podemos generar el "back" de la siguiente manera:
     /// 1. En el controlador de la vista de origen se agrega el siguiente codigo "IBAction"
     /// 2. En el -view- destino se agrega un boton para regresar, desde este se hacer un ctrl+drag a la opcion de -Exit de su misma -view- y se elige "closeWithSegue:"
    @IBAction func close(segue: UIStoryboardSegue) {
        
        if let VC = segue.source as? SelectIconViewController {
            if let iconName = VC.iconSelected {
//                print("iconName: \(iconName)")
                typeVar = iconName
                iconImageView.image = UIImage(named: typeVar)
            }
        }
    }
    
    
    
    //MARK: - Funciones personales
    
    func getValueDatePicker(dateFormat: String, datePicker: UIDatePicker) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current

        let result = dateFormatter.string(from: datePicker.date)
        return result
    }

}
