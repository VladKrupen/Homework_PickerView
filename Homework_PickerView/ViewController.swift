//
//  ViewController.swift
//  Homework_PickerView
//
//  Created by Vlad on 16.12.23.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        return picker
    }()
    
    var selectedImages: [UIImage] = []
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }

    @IBAction func buttonAddPhotoTapped(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProviders = results.map { $0.itemProvider }
    
        for item in itemProviders {
            item.loadObject(ofClass: UIImage.self) { image, error in
                
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.selectedImages.append(image)
                        self.pickerView.reloadAllComponents()
                        self.imageView.image = self.selectedImages.first
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
        
        // MARK: - Button cancel
        if results.isEmpty {
            picker.dismiss(animated: true)
        }
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedImages.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 120
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        pickerImageView.contentMode = .scaleAspectFill
        pickerImageView.clipsToBounds = true
        pickerImageView.image = selectedImages[row]
        pickerImageView.layer.cornerRadius = 50

        return pickerImageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if !selectedImages.isEmpty {
            imageView.image = selectedImages[row]
        }
        
    }
    
    
}

