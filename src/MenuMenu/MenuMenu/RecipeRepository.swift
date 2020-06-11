//
//  RecipeDao.swift
//  MenuMenu
//
//  Created by jinkyuhan on 2020/06/11.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
class RecipeRepository {
    static let shared = RecipeRepository()
    private let dbManager : DBManager
    
    private init(){
        self.dbManager = DBManager.shared
    }
    
    func getAllRecipeSummaryViews() -> [RecipeSummaryView]? {
        self.dbManager.openDatabase()
        defer {
            self.dbManager.closeDatabase()
        }
        let query = "SELECT * FROM recipe_summary_view"
        var recipeSummaryViews: [RecipeSummaryView] = [RecipeSummaryView]()
        
        if let results = self.dbManager.execQuery(queryString: query) {
            for result in results {
                let id: Int =  Int(result["recipe_id"]!)!
                let foodName: String! = result["food_name"]!
                let imgPath: URL? = URL(string: result["food_image_URL"]!)
                let recipeSummary = RecipeSummaryView(id: id, name: foodName, imgPath: imgPath)
                recipeSummaryViews.append(recipeSummary)
            }
            return recipeSummaryViews
        }
        return nil
    }
    
    func getRecipeById(id: Int) -> Recipe? {
        self.dbManager.openDatabase()
        defer {
            self.dbManager.closeDatabase()
        }
        let queryForIngredient = """
SELECT r.recipe_id, r.food_name, r.food_image_URL, i.ingredient_name, i.amount
FROM recipe_basic r INNER JOIN recipe_ingredient i  ON  r.recipe_id = i.recipe_id and r.recipe_id= \(id)
ORDER BY i.ingredient_id;
"""
        let queryForProcess = """
SELECT r.recipe_id, r.food_name, p.process_order, p.description
FROM recipe_basic r INNER JOIN recipe_process p  ON  r.recipe_id = p.recipe_id and r.recipe_id= \(id)
ORDER BY p.process_order;
"""
        var recipeId: Int = 0
        var foodName: String = ""
        var imgPath: String = ""
        var ingredients : [Ingredient] = [Ingredient]()
        var process : [String] = [String]()
        
        if let resultsForIngredient = dbManager.execQuery(queryString: queryForIngredient) {
            for result in resultsForIngredient {
                recipeId = Int(result["recipe_id"]!)!
                foodName = result["food_name"]!
                imgPath = result["food_image_URL"] ?? ""
                ingredients.append(Ingredient(name: result["ingredient_name"]!,amount: result["amount"]!))
            }
        } else {
            return nil
        }
        
        if let resultsForProcess = dbManager.execQuery(queryString: queryForProcess) {
            for result in resultsForProcess {
                process.append(result["description"]!)
            }
        } else {
            return nil
        }
        
        return Recipe(id: recipeId, foodName: foodName, ingredients: ingredients, process: process, imgPath: URL(string: imgPath))
    }
    

}
