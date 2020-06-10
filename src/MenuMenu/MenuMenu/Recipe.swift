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
    var ingredients: [Ingredient]
    var process: [String]
    var imgPath: URL?
    
    init(id: Int, foodName: String, ingredients: [Ingredient], process : [String], imgPath : URL?){
        self.id = id
        self.foodName = foodName
        self.ingredients = ingredients
        self.process = process
        self.imgPath = imgPath
    }
}
