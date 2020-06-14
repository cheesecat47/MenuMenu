//
//  ViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/23.
//  Copyright © 2020 COMP420. All rights reserved.
//

// reference
// https://devmjun.github.io/archive/SearchController

import UIKit

class RecipeDetailViewContoller: UIViewController {

    @IBOutlet weak var recipeDetailNameLabel: UILabel!
    @IBOutlet weak var recipeDetailImageView: UIImageView!
    @IBOutlet weak var recipeDetailTableView: UITableView!
    @IBOutlet weak var recipeDetailDescriptionLabel: UITextView!
    
    
    var detailRecipe: Recipe? {
        didSet {
            dump("RecipeDetailViewContoller: detailRecipe: \(String(describing: detailRecipe?.foodName))")
            configureView()
        }
    }
    
    func configureView() {
        // input data in the specific views
        if let detailRecipe = detailRecipe {
            // set food name
            if let recipeDetailNameLabel = recipeDetailNameLabel {
                dump("RecipeDetailViewContoller: configureView: \(String(describing: detailRecipe.foodName))")
                recipeDetailNameLabel.text = detailRecipe.foodName
            }
            // set image
            self.imageURL = detailRecipe.imgPath
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //////////////////////////////////////////////////////////////
    // Set Image
    //////////////////////////////////////////////////////////////
    
    var imageURL: URL? {
        didSet {
            if let recipeDetailImageView = recipeDetailImageView {
                recipeDetailImageView.image = nil
                if view.window != nil {
                    fetchImage()
                }
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, let recipeDetailImageView = self?.recipeDetailImageView {
                        recipeDetailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if recipeDetailImageView.image == nil {
            fetchImage()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        // ex1) Get All RecipeSummaryView
//        if let views = RecipeRepository.shared.getAllRecipeSummaryViews(){
//            for (_, view) in views.enumerated() {
//                print("id: \(view.id)")
//                print("name: \(view.foodName)")
//                print("imagePath: \(String(describing: view.imgPath?.absoluteString))\n")
//            }
//        }
        
        // ex2) Get All Recipes
//        if let recipes = RecipeRepository.shared.getAllRecipes() {
//            for (_, recipe) in recipes {
//                print("id : \(recipe.id)")
//                print("name: \(recipe.foodName)")
//                print("imgPath:  \(String(describing: recipe.imgPath?.absoluteString))") // 테스트용이라 옵셔널 무시
//                print("----Ingredients----")
//                for (i, ingredient) in recipe.ingredients.enumerated() {
//                    print("\(i+1). \(ingredient.name) \(ingredient.amount)")
//                }
//                print("----How to make----")
//                for (i, process) in recipe.process.enumerated() {
//                    print("\(i+1). \(process)")
//                }
//                print("")
//            }
//        }
        
        // ex3) Get Recipe by ID
//        if let recipe = RecipeRepository.shared.getRecipeById(id: 10){
//            print("id : \(recipe.id)")
//            print("name: \(recipe.foodName)")
//            print("filePath:  \(String(describing: recipe.imgPath?.absoluteString))")
//            print("----Ingredients----")
//            for (i, ingredient) in recipe.ingredients.enumerated() {
//                print("\(i+1). \(ingredient.name) \(ingredient.amount)")
//            }
//            print("----How to make----")
//            for (i, process) in recipe.process.enumerated() {
//                print("\(i+1). \(process)")
//            }
//            print("")
//        }
        
        
        // ex4) Get All Ingredient Names
//        print("----Ingredients List----")
//        let ingredientNames = RecipeRepository.shared.getAllIngredientName()
//        for (i, name) in ingredientNames.enumerated() {
//            print("\(i). \(name)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

