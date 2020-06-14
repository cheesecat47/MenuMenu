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
    @IBOutlet weak var recipeDetailTableView: UITextView!
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
            // set ingredient table
            if let recipeDetailDescriptionLabel = recipeDetailDescriptionLabel {
                var processConcate = ""
                for (i, thisProcess) in detailRecipe.process.enumerated(){
                    processConcate += "\(i+1). \(thisProcess)\n"
                }
                dump("RecipeDetailViewContoller: configureView: \(String(describing: processConcate))")
                recipeDetailDescriptionLabel.text = processConcate
            }
            
            // set description
            if let recipeDetailTableView = recipeDetailTableView {
                var ingredientsConcate = ""
                for (i, ingredient) in detailRecipe.ingredients.enumerated(){
                    ingredientsConcate += "\(i+1). \(ingredient.name) \(ingredient.amount)\n"
                }
                dump("RecipeDetailViewContoller: configureView: \(String(describing: ingredientsConcate))")
                recipeDetailTableView.text = ingredientsConcate
            }
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

