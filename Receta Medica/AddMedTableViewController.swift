//
//  AddMedTableViewController.swift
//  Prescription Reminder (from)
//
//  Created by Jorge Collins Gómez on 02/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddMedTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    var quantityVar = 0.0
    @IBOutlet weak var quantityTextField: UITextField!
    
    var periodicityInHoursValueVar = ""
    @IBOutlet weak var periodicityInHoursDatePicker: UIDatePicker!
    
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

        self.tableView.delegate = self
        self.tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
//        self.tableView.
                
        periodicityInHoursValueVar = getValueDatePicker(dateFormat: "HH:mm", datePicker: periodicityInHoursDatePicker)
        
        daysToTakeTextField.isUserInteractionEnabled = false
        
        firstDoseValueVar = getValueDatePicker(dateFormat: dateFormat, datePicker: firstDoseDatePicker)
        
        
        // Valores por defecto de prueba
//        nameTextField.text = "Nombremedicamentoprueba"
//        quantityTextField.text = "1/4"
//        daysToTakeTextField.text = "1"
        
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

    @IBAction func periodicityInHoursDatePicker(_ sender: Any) {
        periodicityInHoursValueVar = getValueDatePicker(dateFormat: "HH:mm", datePicker: periodicityInHoursDatePicker)
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
                // Agregar la newAlert al array de alertas como tipo string
                let newAlertAsStr = Parsing.shared.dateToString(date: newAlert, localeId: localeId, dateFormat: dateFormat)
                doseAlerts[newAlertAsStr] = true as AnyObject
                
                /// Agregar una LocalNotification
                // Obtenemos la forma como deseamos que se vea la hora
                let medTime = Parsing.shared.dateToString(date: newAlert, localeId: localeId, dateFormat: "H:mm")
                // Agregamos la notificación
                _ = Parsing.shared.setLocalNotification(date: newAlert, title: "\(nameValue) - \(quantityValue)", subtitle: "", body: medTime, badge: 1)
                /// EOF
                
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
