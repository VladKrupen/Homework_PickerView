//
//  ViewController.swift
//  Homework_PickerView
//
//  Created by Vlad on 16.12.23.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {
   
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        return picker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.contentMode = .scaleAspectFill

    }

    @IBAction func buttonAddPhotoTapped(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProviders = results.map { $0.itemProvider }
        
        for item in itemProviders {
            item.loadObject(ofClass: UIImage.self) { image, error in
                let image = image as? UIImage
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        picker.dismiss(animated: true)
        
        // MARK: - Button cancel
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
        
    }
    
}

