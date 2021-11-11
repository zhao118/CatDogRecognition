//
//  CameraPicker.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/9.
//

import UIKit
import CoreML //机器学习需要的包
import Vision //机器学习的图像识别需要使用的包.g19

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cameraPicker: UIImagePickerController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        return cameraPicker
        
    }
    
    /// The delegate method UIKit calls when the user takes a photo with the camera.
    /// - Parameters:
    ///   - picker: A picker controller the `cameraPicker` property created.
    ///   - info: A dictionary that contains the photo.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true )
        
        // Always return the original image.
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] else {
            fatalError("Picker didn't have an original image.")
        }
        
        guard let photo = originalImage as? UIImage else {
            fatalError("The (Camera) Image Picker's image isn't a/n \(UIImage.self) instance.")
        }
        
        self.imageViewM.image = photo
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
