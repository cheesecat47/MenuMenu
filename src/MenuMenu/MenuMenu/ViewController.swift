//
//  ViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/23.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FOR DEBUG
        if let views = RecipeRepository.shared.getAllRecipeSummaryViews(){
            for (i, view) in views.enumerated() {
                print("id: \(view.id)")
                print("name: \(view.foodName)")
                print("imagePath: \(view.imgPath?.absoluteString)\n")
            }
        }
        
        if let recipe = RecipeRepository.shared.getRecipeById(id: 10){
            print("id : \(recipe.id)")
            print("name: \(recipe.foodName)")
            print("filePath:  \(recipe.imgPath?.absoluteString)")
            print("----Ingredients----")
            for (i, ingredient) in recipe.ingredients.enumerated() {
                print("\(i+1). \(ingredient.name) \(ingredient.amount)")
            }
            print("----How to make----")
            for (i, process) in recipe.process.enumerated() {
                print("\(i+1). \(process)")
            }
            print("")
        }
        // FOR DEBUG END
    }
    
}

