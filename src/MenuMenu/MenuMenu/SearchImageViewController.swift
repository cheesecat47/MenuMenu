//
//  FoodCameraController.swift
//  MenuMenu
//
//  Created by refo on 2020/06/04.
//  Copyright © 2020 COMP420. All rights reserved.
//

// references
// https://zeddios.tistory.com/125


import UIKit

class SearchImageViewController: UIViewController {
    
    let picker = UIImagePickerController()

    @IBOutlet weak var foodImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func foodImageAddAction(_ sender: Any) {
        let alert = UIAlertController(title: "사진을 어디에서 가져오시겠습니까?", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default, handler: {(action) in self.openLibrary()})
        let camera = UIAlertAction(title: "카메라", style: .default, handler: {(action) in self.openCamera()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}

extension SearchImageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        } else {
            dump("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            foodImageView.image = image
            dump("imagePickerController: InfoKey: \(info)")
        }
        dismiss(animated: true, completion: nil)
    }
}
