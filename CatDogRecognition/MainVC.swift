//
//  ViewController.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/8.
//

import UIKit
import YPImagePicker
import CoreML //机器学习需要的包
import Vision //机器学习的图像识别需要使用的包.g19

class MainVC: UIViewController {
    
    var photo: UIImage!
    
    var flag = true
    
    @IBOutlet weak var animalLabel: UILabel!
    
    @IBOutlet weak var imageViewM: UIImageView!
    
    @IBOutlet weak var animalTraitTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //识别照片-从TabBar中点击相机进入
        modelRecognitionImage( photo, animalLabel, animalTraitTextView )
        
        if flag { imageViewM.image = photo }
        
        self.title = "动物识别"
        
        print(animalsImages.count)
    }
    
    
    @IBAction func photoBtn(_ sender: UIButton) {
        
        flag = false
        
        let picker = YPImagePicker(configuration: config)
        
        //[unowned picker]捕获列表(unowned弱引用).49
        // 当控制台打印出 Picker deinited时,代表picker实例已经析构掉了,不会占用内存,因为使用了捕获列表避免了循环引用
        picker.didFinishPicking { [unowned picker] items, cancelled in
            //点击取消,没有选择图片
            if cancelled{
                
                picker.dismiss(animated: true, completion: nil)
                
            }else{
                //只允许选择单个照片
                guard let photo = items.singlePhoto else { return }
                
                let modelImage = photo.image
                
                //识别照片-点击动物识别页的拍照按钮进入
                self.modelRecognitionImage( modelImage, self.animalLabel, self.animalTraitTextView )
                
                picker.dismiss(animated: true, completion: nil )
                
                self.imageViewM.image = modelImage
                
               
            }
            
        }
        
        
        //执行顺序-创建了picker实例之后,先present出picker选择图片,选择图片完成后进入到didFinishPicking执行闭包(回调函数)中相关代码,并dismiss掉picker
        //这种执行的顺序在与后端连接的时候经常会出现
        present(picker, animated: true )
       
    }
    
    
}

