//
//  DetailViewController.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 01/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var medImageView: UIImageView!
    
    var med : Med!
    var localeId = Locale.preferredLanguages[0] // Obtenemos el lenguaje seleccionado como principal de la App "es_ES" (que no es lo mismo que el lenguaje del dispositivo)
    var dates = [String]()
    var status = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        self.medImageView.image = UIImage(named: med.type)

        // Ordenamos las alertas
        let dictValInc = self.med.alerts.sorted(by: { $0.key < $1.key })
        
        for item in dictValInc {
            dates.append(item.key)
            status.append(item.value as! Bool)

        }
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Para deseleccionar el renglon de la tabla
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "· Información general"
        case 1:
            return "· Alarmas"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 3
        case 1:
            return self.med.alerts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewCell


        switch indexPath.section {
            case 0:
                // --- Aqui dentro toda la logica de los renglones de la primera sección
                switch indexPath.row {
                case 0:
                    cell.keyLabel.text = "Medicina"
                    cell.valueLabel.text = self.med.name
                    
                case 1:
                    cell.keyLabel.text = "Cantidad"
                    cell.valueLabel.text = self.med.quantity
                    
                case 2:
                    cell.keyLabel.text = "Siguiente dosis"
                    
                    var nextDose = ""
                    let dateNow = Date()
                    for date in self.dates {
                        let dateAsDate = Parsing.shared.stringToDate(string: date, dateFormat: "yyyy-MM-dd HH:mmZ")
                        
                        let resultCompare = Calendar.current.compare(dateAsDate, to: dateNow, toGranularity: .minute)
                        if resultCompare == ComparisonResult.orderedDescending {
                            nextDose = Parsing.shared.dateToString(date: dateAsDate, localeId: localeId, dateFormat: "H:mm EEEE, dd·MMM·yyyy")
                            
                            break
                        }
                    }
                    cell.valueLabel.text = nextDose == "" ? "Terminado" : nextDose
                    
                default:
                    break
                }
                // --- EOF
            case 1:
                cell.keyLabel.text = "Toma " + String(indexPath.row + 1)

                /* Lo de "indicator" esta comentado en lo que resolvemos como programar una alarma y guardar el resultado del -action- presionado en la celdaa
                 */
                // Sí la toma de medicina sigue pendiente (true)...
                if status[indexPath.row] {
                    // Lo indicamos con una casilla vacia
                    // cell.accessoryView = UIImageView(image: UIImage(named: "indicator1"))
                } else {
                    // Si ya se tomo, lo indicamos con una casilla palomeada
                    // cell.accessoryView = UIImageView(image: UIImage(named: "indicator1_chk"))
                }
               
                let alarmDate = Parsing.shared.stringToDate(string: dates[indexPath.row], dateFormat: "yyyy-MM-dd HH:mmZ")
                let alarmValue = Parsing.shared.dateToString(date: alarmDate, localeId: localeId, dateFormat: "H:mm',' dd-MMM-yy")

                cell.valueLabel.text = alarmValue

            default:
                break
            }
        
        return cell
    }
    
    
}
