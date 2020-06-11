//
//  ViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/23.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView = UIImageView()
    var imageURL: URL? {
        didSet {
            image = nil
            imageView.sizeToFit()
            if view.window != nil {
                fetchImage()
            }
        }
    }
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
        }
    }
//    var ingredients: String = []
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage() {
               if let url = imageURL {
                   spinner.startAnimating()
                   DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                       let urlContents = try? Data(contentsOf: url)
                       DispatchQueue.main.async {
                           if let imageData = urlContents, url == self?.imageURL {
                               self?.image = UIImage(data: imageData)
                           }
                       }
                       
                   }
               }
           }
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FOR DEBUG
        if let views = RecipeRepository.shared.getAllRecipeSummaryViews(){
            for (_, view) in views.enumerated() {
                print("id: \(view.id)")
                print("name: \(view.foodName)")
                print("imagePath: \(String(describing: view.imgPath?.absoluteString))\n")
            }
        }
        
        if let recipe = RecipeRepository.shared.getRecipeById(id: 10){
            print("id : \(recipe.id)")
            print("name: \(recipe.foodName)")
            print("filePath:  \(String(describing: recipe.imgPath?.absoluteString))")
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

