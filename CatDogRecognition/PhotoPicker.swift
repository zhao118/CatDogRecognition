//
//  PhotoPicker.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/9.
//

import PhotosUI

extension ViewController: PHPickerViewControllerDelegate {
    
    //计算属性
    var photoPicker: PHPickerViewController {
        
        var config = PHPickerConfiguration()
        //允许选择的数量,0没有限制
        config.selectionLimit = 1
        //选择类型为images图片
        config.filter = .images
        
        let photoPikcer = PHPickerViewController(configuration: config)
        photoPikcer.delegate = self
        
        return photoPikcer
    }
    
    /// The delegate method UIKit calls when the user selects a photo from the library.
    /// - Parameters:
    ///   - picker: A picker controller the `photoPicker` property created.
    ///   - results: An array of results. The method presumes the first result contains a photo.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }
            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }
            
           
            
        }
        
    }
}

