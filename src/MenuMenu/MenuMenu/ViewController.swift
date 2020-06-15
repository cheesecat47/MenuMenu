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
        
        // ex1) Get All RecipeSummaryView
        if let views = RecipeRepository.shared.getAllRecipeSummaryViews(){
            for (_, view) in views.enumerated() {
                print("id: \(view.id)")
                print("name: \(view.foodName)")
                print("imagePath: \(view.imgPath?.absoluteString)\n") // 테스트용이라 옵셔널 무시
            }
        }

        // ex2) Get All Recipes
        if let recipes = RecipeRepository.shared.getAllRecipes() {
            for (_, recipe) in recipes {
                print("id : \(recipe.id)")
                print("name: \(recipe.foodName)")
                print("imgPath:  \(recipe.imgPath?.absoluteString)") // 테스트용이라 옵셔널 무시
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
        }

        // ex3) Get Recipe by ID
        if let recipe = RecipeRepository.shared.getRecipeById(id: 10){
            print("id : \(recipe.id)")
            print("name: \(recipe.foodName)")
            print("imgPath:  \(recipe.imgPath?.absoluteString)") // 테스트용이라 옵셔널 무시
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


        // ex4) Get All Ingredient Names
        print("----Ingredients List----")
        let ingredientNames = RecipeRepository.shared.getAllIngredientName()
        for (i, name) in ingredientNames.enumerated() {
            print("\(i). \(name)")
        }
        
        // ex5) Get id of recipes by ingredients names
        if let recipesId = RecipeRepository.shared.getRecipesIdByIngredientNames(ingredientNames: ["소금", "라면스프"]){
            for id in recipesId{
                print(id)
            }
        }

    }
    
}

