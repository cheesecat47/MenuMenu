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
    
    func getAllRecipes() -> Dictionary<Int, Recipe>? {
        self.dbManager.openDatabase()
        defer {
            self.dbManager.closeDatabase()
        }
        let queryForIngredient = """
        SELECT r.recipe_id, r.food_name, r.food_image_URL, i.ingredient_name, i.amount, i.type
        FROM recipe_basic r INNER JOIN recipe_ingredient i  ON  r.recipe_id = i.recipe_id
        ORDER BY r.recipe_id;
        """
        let queryForProcess = """
        SELECT r.recipe_id, r.food_name, p.process_order, p.description
        FROM recipe_basic r INNER JOIN recipe_process p  ON  r.recipe_id = p.recipe_id
        ORDER BY r.recipe_id, p.process_order;
        """
        
        var recipes = Dictionary<Int, Recipe>()
        
        if let resultsForIngredient = dbManager.execQuery(queryString: queryForIngredient) {
            for result in resultsForIngredient {
                let id = Int(result["recipe_id"]!)!
                if let recipe = recipes[id]{ // if it's already exist
                    recipe.ingredients.append(Ingredient(name: result["ingredient_name"]!, amount: result["amount"]!, type: result["type"]!))
                } else { // if it's not exist
                    let newRecipe = Recipe(id: id)
                    newRecipe.foodName = result["food_name"]!
                    newRecipe.imgPath = URL(string: result["food_image_URL"] ?? "")
                    newRecipe.ingredients.append(Ingredient(name: result["ingredient_name"]!,amount: result["amount"]!, type: result["type"]!))
                    recipes[id] = newRecipe
                }
            }
        } else {
            return nil
        }
        
        if let resultsForProcess = dbManager.execQuery(queryString: queryForProcess) {
            for result in resultsForProcess {
                let id = Int(result["recipe_id"]!)!
                if let recipe = recipes[id]{
                    recipe.process.append(result["description"]!)
                }
            }
        } else {
            return nil
        }
        return recipes
    }
    
    func getRecipeById(id: Int) -> Recipe? {
        self.dbManager.openDatabase()
        defer {
            self.dbManager.closeDatabase()
        }
        let queryForIngredient = """
        SELECT r.recipe_id, r.food_name, r.food_image_URL, i.ingredient_name, i.amount, i.type
        FROM recipe_basic r INNER JOIN recipe_ingredient i  ON  r.recipe_id = i.recipe_id and r.recipe_id= \(id)
        ORDER BY i.ingredient_id;
        """
        let queryForProcess = """
        SELECT r.recipe_id, r.food_name, p.process_order, p.description
        FROM recipe_basic r INNER JOIN recipe_process p  ON  r.recipe_id = p.recipe_id and r.recipe_id= \(id)
        ORDER BY p.process_order;
        """
        var recipeId = 0
        var foodName = ""
        var imgPath = ""
        var ingredients = [Ingredient]()
        var process = [String]()
        
        if let resultsForIngredient = dbManager.execQuery(queryString: queryForIngredient) {
            for result in resultsForIngredient {
                recipeId = Int(result["recipe_id"]!)!
                foodName = result["food_name"]!
                imgPath = result["food_image_URL"] ?? ""
                ingredients.append(Ingredient(name: result["ingredient_name"]!,amount: result["amount"]!, type: result["type"]!))
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
        let recipe = Recipe(id: recipeId)
        recipe.foodName = foodName
        recipe.ingredients = ingredients
        recipe.process = process
        recipe.imgPath = URL(string: imgPath)
        
        return recipe
    }
    
    func getAllIngredientName() -> [String] {
        self.dbManager.openDatabase()
        defer {
            self.dbManager.closeDatabase()
        }

        let query = """
        SELECT DISTINCT ingredient_name
        FROM recipe_ingredient
        ORDER BY ingredient_name
        """
        var ingredientNames = [String]()
        if let results = dbManager.execQuery(queryString: query) {
            for result in results {
                ingredientNames.append(result["ingredient_name"]!)
            }
        }
        return ingredientNames
    }
}
