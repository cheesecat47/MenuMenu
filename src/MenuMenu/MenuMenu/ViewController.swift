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
        let testImageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png")
        if image == nil {
                imageURL = testImageURL
        }
        // Do any additional setup after loading the view.
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

