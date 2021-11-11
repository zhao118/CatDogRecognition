//
//  Note .swift
//  CatDogRecognition
//
//  Created by ZhaoQ on 2021/11/10.
//
// 使用包来做拍照和从相册中选择图片
//需要在info.plist中配置权限-使用相机的权限,从相册中选择照片的权限,如果使用了UIimagePickerController就不需要配置从相册中选取照片的权限,还有存储照片的权限
//可以选择相册中的图片(UIImagePicker的功能),可以拍照,可以存照片到本地
//当控制台打印出 Picker deinited时,代表picker实例已经析构掉了,不会占用内存,因为使用了捕获列表(unowned弱引用)避免了循环引用
