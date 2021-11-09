//
//  ViewController.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/8.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewM: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pickerBtn(_ sender: Any) {
        
        //用户点下照相机按钮时才委托-省资源,不用再开始加载就委托当前类(设置代理为self),即不用在viewDidLoad中设置delegate为self .g18
        present(cameraPicker, animated: true, completion: nil )
        
    }
    
}

