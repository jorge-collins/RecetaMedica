//
//  MedsTableViewController.swift
//  Prescription Reminder (from)
//
//  Created by Jorge Collins Gómez on 29/04/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class MedsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    
    var user : User!
    
    private var meds = [Med]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
               
        // Cargamos la tableView con la info
        loadTableViewFromScratch()
        
    }


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Mis medicinas – \(self.user.firstName) \(self.user.lastName)"
        }
        return "0"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedCell", for: indexPath) as! MedTableViewCell
        cell.imageView?.contentMode = .scaleAspectFit
        let med = self.meds[indexPath.row]
//        print("--med: \(med)")

        cell.imageView?.image = UIImage(named: med.type) // La celda incluye una imagen y asi se asigna
        cell.textLabel?.text = med.name
        
        // Aqui debo generar la forma de mostrar el tiempo mas amigablemente
        
//        cell.detailTextLabel?.text = "\(med.quantity) cada \(med.periodicityInHours) horas."

        let timeInFraction = Parsing.shared.timeAsFraction(time: med.periodicityInHours, format: "HH:mm")
        cell.detailTextLabel?.text = "\(med.quantity) cada \(timeInFraction)."
        
        return cell
    }
    
    /* Eliminar un elemento con swipe a la izq("editingStyle") y presionar el boton "Delete" */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Confirmamos si el botón presionado es el .delete
        if editingStyle == .delete {
            // Recuperamos el elemento por medio del indexPath
            let med = self.meds[indexPath.row]
            // Eliminamos de la base de datos
            DatabaseService.shared.deleteMed(medid: med.medid)
            // Eliminamos el elemento de la estructura de datos
            self.meds.remove(at: indexPath.row)
        }
        // Eliminamos el renglon de la tabla
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Para deseleccionar el renglon de la tabla
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMedDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedMed = self.meds[indexPath.row]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.med = selectedMed
                print("prepare for segue: \(selectedMed)")
            }
        }
    }
    
    // MARK: Navigation
    
    @IBAction func unwindTo(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToMedsTableSegue" {
            
            if let addMedVC = segue.source as? AddMedTableViewController {
                if let newMed = addMedVC.med {
                    print("newMed: \(newMed)")

                    loadTableViewFromScratch()
                    
                }
            }
        }
        
    }
    
    // Remueve todos los elementos del array de elementos y lo recarga con la DB, asi mismo con el tableView
    func loadTableViewFromScratch() {
        // Limpiamos el array
        self.meds.removeAll()
        // -- Recuperamos la info del snapshot
        DatabaseService.shared.medsRef.observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            if let meds = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in meds { //*
                    if let dict = value as? Dictionary<String, AnyObject> { //**
                        if self.user.userid == dict["userid"] as? String { //***
                            
                            if let name = dict["name"] as? String,
                                let userid = dict["userid"] as? String,
                                let type = dict["type"] as? String,
                                let mediaURL = dict["mediaURL"] as? String,
                                let daysToTake = dict["daysToTake"] as? String,
                                let firstDose = dict["firstDose"] as? String,
                                let periodicityInHours = dict["periodicityInHours"] as? String,
                                let quantity = dict["quantity"] as? String,
                                let alerts = dict["alerts"] as? Dictionary<String, AnyObject> { //****
                                    let medid = key

                                    let med = Med(medid: medid, userid: userid, name: name, type: type, mediaURL: mediaURL, daysToTake: daysToTake, firstDose: firstDose, periodicityInHours: periodicityInHours, quantity: quantity, alerts: alerts)
                                    self.meds.append(med)
                            } //****
                        } //***
                    } //**
                } //*
                self.meds.sort { $0.name < $1.name }
                self.tableView.reloadData()
            }
            //--
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        // Se realiza el signOut en Firebase
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            } catch let err {
                print(err)
            }
    }
}
