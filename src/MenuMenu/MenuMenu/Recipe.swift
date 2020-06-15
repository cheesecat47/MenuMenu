//
//  Recipe.swift
//  MenuMenu
//
//  Created by jinkyuhan on 2020/06/11.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
class Recipe {
    var id: Int
    var foodName: String
    var imgPath: URL?
    var ingredients: [Ingredient]
    var process: [String]
    
    
    init(id: Int) {
        self.id = id
        self.foodName = ""
        self.imgPath = nil
        self.ingredients = [Ingredient]()
        self.process = [String]()
    }
}
