//
//  Ingredient.swift
//  MenuMenu
//
//  Created by jinkyuhan on 2020/06/11.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
class Ingredient {
    var name : String
    var amount : String
    var type : String
    init(name: String, amount: String, type: String){
        self.name = name
        self.amount = amount
        self.type = type
    }
}
