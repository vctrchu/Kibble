//
//  PetIds.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-04-21.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import Foundation

struct Pet {
    private var _id: String
    private var _name: String
    private var _type: String
    private var _photoUrl: String?

    var id: String {
        set { _id = newValue }
        get { return _id }
    }

    var name: String {
        set { _name = newValue }
        get { return _name }
    }

    var type: String {
        set { _type = newValue }
        get { return _type }
    }

    var photoUrl: String? {
        set { _photoUrl = newValue }
        get { return _photoUrl }
    }

    init(_ id: String, _ name: String, _ type: String, _ photoUrl: String?) {
        self._id = id
        self._name = name
        self._type = type
        self._photoUrl = photoUrl
    }
}
