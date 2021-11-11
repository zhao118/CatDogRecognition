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

class ViewController: UIViewController {
    
    var photos: [UIImage] = []
    
    @IBOutlet weak var imageViewM: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pickerBtn(_ sender: Any) {
        
        //用户点下照相机按钮时才委托-省资源,不用再开始加载就委托当前类(设置代理为self),即不用在viewDidLoad中设置delegate为self .g18
        present(cameraPicker, animated: true )
        
    }
    
    @IBAction func photoBtn(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        //只允许拍正方形的照片,大小都一样,更加美观.50
        config.onlySquareImagesFromCamera = true
        //是否启用滤镜功能
        config.showsPhotoFilters = true
        //简单的视频剪辑处理
        config.showsVideoTrimmer = true
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
        //带有配置的实例化
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
                self.imageViewM.image = photo.image
                let imageModel = photo.image
                
                //1.转换图片类型
                guard let CiImage = CIImage(image: imageModel) else { fatalError("不能转化为CIImage类型") }
                
                //2.加载模型
                guard let model = try? VNCoreMLModel(for: ChiAnimals().model) else { fatalError("加载MLmodel失败") }
                
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
                
                //图库中选择的照片和拍摄的照片
                self.photos.append(photo.image)
                
                picker.dismiss(animated: true, completion: nil )
            }
            
        }
        
        // present(photoPicker, animated: true )
        //执行顺序-创建了picker实例之后,先present出picker选择图片,选择图片完成后进入到didFinishPicking执行闭包(回调函数)中相关代码,并dismiss掉picker
        //这种执行的顺序在与后端连接的时候经常会出现
        present(picker, animated: true, completion: nil)
    }
    
}

