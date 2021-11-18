//
//  Extension-System.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/11.
//


import UIKit
import YPImagePicker
import CoreML //机器学习需要的包
import Vision //机器学习的图像识别需要使用的包.g19

var config: YPImagePickerConfiguration {
    var config = YPImagePickerConfiguration()
    //只允许拍正方形的照片,大小都一样,更加美观.50
    config.onlySquareImagesFromCamera = true
    //是否启用滤镜功能
    config.showsPhotoFilters = false
    //简单的视频剪辑处理
    config.showsVideoTrimmer = false
    //默认打开相册或相机
    config.startOnScreen = .photo
    //下面的栏展示几种功能按钮
    config.screens = [.library, .photo]
    //展示的照片是正方形还是原图的尺寸比例，true正方形
    config.library.isSquareByDefault = true
    //用户可以选择相册里面的媒体类型,视频，照片，视频和照片
    config.library.mediaType = .photo
    //false单选，true多选
    config.library.defaultMultipleSelection = false
    //打开相册之后不会自动选中第一张图片
    config.library.preSelectItemOnMultipleSelection = false
    //是否需要跳过编辑的页面
    config.library.skipSelectionsGallery = true
    //当点击下一步的时候是否保存图片(didFinishPicking中从相册中选择的或拍摄的照片,或是滤镜后的照片)
    config.shouldSaveNewPicturesToAlbum = true
    //存照片的相簿名称-使用info.plist中Bundledisplayname(Raw Keys为CFBundleDisplayName)的包名称.51
    config.albumName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    
    return config
    
}

extension UIViewController {
    
    //使用模型识别图片
    func modelRecognitionImage(_ imageModel: UIImage, _ animalLabel: UILabel, _ animalTraitTextView: UITextView  ) {
        
        //1.转换图片类型
        guard let CiImage = CIImage(image: imageModel) else { fatalError("不能转化为CIImage类型") }
        
        //2.加载模型
        guard let model = try? VNCoreMLModel(for: ChiAnimals().model) else { fatalError("加载MLmodel失败") }
        
        //3.生成一个请求.回调函数(闭包)中输出识别后的结果
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let res = request.results else {
                animalLabel.text = "图像识别失败"
                return
                
            }
            
            let classifications = res as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                animalLabel.text = "不知道是什么"
            }else{
                
                //已经进行了是否为空的判断,所以这里就一个有值,可以给first强制解包
                let animalName = classifications.first!.identifier
                
                //识别后的动物名称
                animalLabel.text = animalName
                
                if animalName == "斑马"{
                    animalTraitTextView.text  = animalsTraits[0]
                }else if animalName == "狐狸" {
                    animalTraitTextView.text = animalsTraits[1]
                }else if animalName == "犀牛" {
                    animalTraitTextView.text = animalsTraits[2]
                }else if animalName == "鲸鱼" {
                    animalTraitTextView.text = animalsTraits[3]
                }else if animalName == "蜜蜂" {
                    animalTraitTextView.text = animalsTraits[4]
                }else if animalName == "鹿" {
                    animalTraitTextView.text = animalsTraits[5]
                }else if animalName == "鸽子" {
                    animalTraitTextView.text = animalsTraits[6]
                }else if animalName == "大象" {
                    animalTraitTextView.text = animalsTraits[7]
                }else if animalName == "刺猬" {
                    animalTraitTextView.text = animalsTraits[8]
                }else if animalName == "海马" {
                    animalTraitTextView.text = animalsTraits[9]
                }else if animalName == "海豚" {
                    animalTraitTextView.text = animalsTraits[10]
                }else if animalName == "老虎" {
                    animalTraitTextView.text = animalsTraits[11]
                }else if animalName == "猫" {
                    animalTraitTextView.text = animalsTraits[12]
                }else if animalName == "狗" {
                    animalTraitTextView.text = animalsTraits[13]
                }else if animalName == "奶牛" {
                    animalTraitTextView.text = animalsTraits[14]
                }else if animalName == "树袋熊" {
                    animalTraitTextView.text = animalsTraits[15]
                }else if animalName == "水母" {
                    animalTraitTextView.text = animalsTraits[16]
                }else if animalName == "浣熊" {
                    animalTraitTextView.text = animalsTraits[17]
                }else if animalName == "猫头鹰" {
                    animalTraitTextView.text = animalsTraits[18]
                }else if animalName == "美洲豹" {
                    animalTraitTextView.text = animalsTraits[19]
                }else if animalName == "蜻蜓" {
                    animalTraitTextView.text = animalsTraits[20]
                }else if animalName == "企鹅" {
                    animalTraitTextView.text = animalsTraits[21]
                }else if animalName == "犀鸟" {
                    animalTraitTextView.text = animalsTraits[22]
                }else if animalName == "蜥蜴" {
                    animalTraitTextView.text = animalsTraits[23]
                }else if animalName == "蟹" {
                    animalTraitTextView.text = animalsTraits[24]
                }else if animalName == "猩猩" {
                    animalTraitTextView.text = animalsTraits[25]
                }else if animalName == "熊猫" {
                    animalTraitTextView.text = animalsTraits[26]
                }else if animalName == "驯鹿" {
                    animalTraitTextView.text = animalsTraits[27]
                }else if animalName == "鸭子" {
                    animalTraitTextView.text = animalsTraits[28]
                }else if animalName == "羊" {
                    animalTraitTextView.text = animalsTraits[29]
                }else if animalName == "野牛" {
                    animalTraitTextView.text = animalsTraits[30]
                    
                    
                    
                }else{
                    animalTraitTextView.text = "暂无介绍......"
                }
                
                
            }
            
        }
        
        //图片转换为正方形,以便于模型识别
        request.imageCropAndScaleOption = .centerCrop
        
        do {
            
            //4.perform-把请求交给模型进行处理(识别图片的请求),处理用户刚拍完的照片固定用法
            try  VNImageRequestHandler(ciImage: CiImage ).perform([request])
            
        }catch {
            print("执行图像识别请求失败,原因是\(error.localizedDescription)")
        }
        
    }
    
}

//在SB中添加属性，用于设置view的圆角效果.84
extension UIView {
    //在SB属性检查器中增加属性.也可以使用关键字实时显示，但是比较耗资源，
    @IBInspectable
    //计算属性
    //注意在扩展系统类时，给里面的属性命名是不要与包中的扩展的属性同名
    //添加成功之后在属性检查器中会展示，首字母大写。每个view都会增加一个radius属性
    var radius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            //增加一个Clips to Bounds避免每次都需要在SB中勾选.x22
            clipsToBounds = true
            //newValue代表cornerRadius的值，
            //这里表示在SB检查器中输入的值,将值传给newValue
            self.layer.cornerRadius = newValue
        }
        
    }
}

