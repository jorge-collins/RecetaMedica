//
//  Med.swift
//  Prescription Reminder
//
//  Created by Jorge Collins Gómez on 30/04/20.
//  Copyright © 2020 CoRoSoftware. All rights reserved.
//

import Foundation

struct Med {
    private var _medid: String
    private var _userid: String
    private var _name: String
    private var _type: String
    private var _mediaURL: String
    private var _daysToTake: String
    private var _firstDose: String
    private var _periodicityInHours: String
    private var _quantity: String
    private var _alerts: Dictionary<String, AnyObject>

    var medid: String { return _medid }
    var userid: String { return _userid }
    var name: String { return _name }
    var type: String { return _type }
    var mediaURL: String { return _mediaURL }
    var daysToTake: String { return _daysToTake }
    var firstDose: String { return _firstDose }
    var periodicityInHours: String { return _periodicityInHours }
    var quantity: String { return _quantity }
    var alerts: Dictionary<String, AnyObject> { return _alerts }

    init(medid: String, userid: String, name: String, type: String, mediaURL: String, daysToTake: String, firstDose: String, periodicityInHours: String, quantity: String, alerts: Dictionary<String, AnyObject>) {
        self._medid = medid
        self._userid = userid
        self._name = name
        self._type = type
        self._mediaURL = mediaURL
        self._daysToTake = daysToTake
        self._firstDose = firstDose
        self._periodicityInHours = periodicityInHours
        self._quantity = quantity
        self._alerts = alerts 
    }
    
}
