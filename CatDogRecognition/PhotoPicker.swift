//
//  PhotoPicker.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/9.
//

import PhotosUI
import CoreML //机器学习需要的包
import Vision //机器学习的图像识别需要使用的包.g19

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
            
            
            
            DispatchQueue.main.async {
                self.imageViewM.image = photo
            }
           
            
            
            
            //1.转换图片类型
            guard let CiImage = CIImage(image: photo) else {
                fatalError("不能转化为CIImage类型")
            }
            //2.加载模型
            //guard let model = try? VNCoreMLModel(for: CatDog().model) else {
            //guard let model = try? VNCoreMLModel(for: ChiCatDog().model) else {
            guard let model = try? VNCoreMLModel(for: ChiAnimals().model) else {
                
                fatalError("加载MLmodel失败")
                
            }
            //3.生成一个请求.回调函数(闭包)中输出识别后的结果
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let res = request.results else {
                    self.navigationItem.title = "图像识别失败"
                    return
                    
                }
                
                let classifications = res as! [VNClassificationObservation]
                if classifications.isEmpty {
                    self.navigationItem.title = "不知道是什么"
                }else{
                    //已经进行了是否为空的判断,所以这里就一个有值,可以给first强制解包
                    self.navigationItem.title = classifications.first!.identifier
                    
                    //已经进行了是否为空的判断,所以这里就一个有值,可以给first强制解包
                    //                if classifications.first!.identifier == "Cat" {
                    //                    self.navigationItem.title = "猫"
                    //                }else {
                    //                    self.navigationItem.title = "狗"
                    //                }
                    
                }
                
            }
            //将要请求识别的图片转换为正方形,以便于模型识别
            request.imageCropAndScaleOption = .centerCrop
            
            do {
                
                //4.perform-把请求交给模型进行处理(识别图片的请求),处理用户刚拍完的照片固定用法
                try  VNImageRequestHandler(ciImage: CiImage ).perform([request])
                
            }catch {
                print("执行图像识别请求失败,原因是\(error.localizedDescription)")
            }
            
           
        }
        
    }
}

