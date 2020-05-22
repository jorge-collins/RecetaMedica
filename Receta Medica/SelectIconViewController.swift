//
//  SelectIconViewController.swift
//  Prescription Reminder (from)
//
//  Created by Jorge Collins Gómez on 09/05/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import UIKit

class SelectIconViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var iconSelected : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Efecto difuminado
        // 1. Generamos el efecto deseado
        let blurEffect = UIBlurEffect(style: .regular)
        // 2. Generamos la vista que contendra el efecto
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 3. Indicamos el tamaño de la vista
        blurEffectView.frame = view.bounds
        // Por medio de su IBOutlet a la imagen deseada, le agregamos la vista con el efecto seleccionado
        backgroundImageView.addSubview(blurEffectView)
    }
    
    @IBAction func iconPressed(_ sender: UIButton) {
        
        iconSelected = String(sender.tag)        
        performSegue(withIdentifier: "unwindSegue", sender: sender) 
    }
    

}
