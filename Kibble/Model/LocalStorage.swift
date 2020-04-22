//
//  LocalStorage.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-21.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation

class LocalStorage {
    static var instance = LocalStorage()

    private var _petIds = Dictionary<String,PetId>()

    var petIds: Dictionary<String,PetId> {
        set { _petIds = newValue }
        get { return _petIds }
    }
}
