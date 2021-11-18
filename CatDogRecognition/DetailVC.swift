//
//  DetailVC.swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/17.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var animalName: UILabel!
    
    @IBOutlet weak var animalImage: UIImageView!
    
    @IBOutlet weak var animalTrait: UILabel!
    
    var animalNameStr: String?
    
    var animalImages: UIImage?
    
    var animalTraitStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animalName.text = animalNameStr
        animalImage.image = animalImages
        animalTrait.text = animalTraitStr
    }
    

    
}
