//
//  Meal.swift
//  Kibble
//
//  Created by VICTOR CHU on 2019-11-14.
//  Copyright © 2019 Victor Chu. All rights reserved.
//

import Foundation

class Meal {
    
    private var _title: String
    private var _isFed: Bool
    private var _description: String
    
    var title: String {
          return _title
      }
      
      var isFed: Bool {
          return _isFed
      }
      
      var description: String {
          return _description
      }
    
    init(title: String, isFed: Bool, description: String) {
        self._title = title
        self._isFed = isFed
        self._description = description
    }
}
