//
//  ViewController.swift
//  MenuMenu
//
//  Created by refo on 2020/05/23.
//  Copyright © 2020 COMP420. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK:- RecipeDetailViewController/UILabel
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeDescriptionTextView: UITextView!
    var recipeTitle = "당근찌개"
    var recipeDescription = "1. 당근을 썬다.\n2. 당근을 끓인다.\n3. 당근을 당근한다."
    
    // MARK:- RecipeDetailViewController/UIImageView
//    static var testImageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png")
//    static var testImageURL = Bundle.main.url(forResource: "carrot", withExtension: "jpg")
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

    
    var recipe_description = "1.재료1을 어디에 넣고 이렇게 한다.\n 2.재료2를 이렇게 저렇게"

    // MARK:- RecipeDetailViewController/UITableView
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients = ["빨강당근", "주황당근", "파란당근"] // Data for test
    var ingredientsAmount = ["1개", "2개", "1.4개"] //Data for test

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! RecipeDetailTableViewCell
        
        cell.ingredientName.text = ingredients[indexPath.row]
        cell.ingredientAmount.text = ingredientsAmount[indexPath.row]
        
        return cell
    }
    
    
    // MARK:- UIViewConroller

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Label and TextView Load
        recipeTitleLabel.text = recipeTitle
        recipeDescriptionTextView.text = recipeDescription
        
        // ImageLoad
        
//        if image == nil {
//            imageURL = RecipeDetailViewController.testImageURL
//        }
        
        // TableLoad
        tableView.delegate = self
        tableView.dataSource = self
        
    }
        


}

