//
//  RuntimeViewController.swift
//  RunTimeSwift
//
//  Created by qwer on 2018/3/30.
//  Copyright © 2018年 qwer. All rights reserved.
//

import UIKit

@objc class UserModel: NSObject {
    
    @objc var name:String? = ""
          var isGirl:Bool? = false
    @objc var address:String? = ""
   
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    //要使用runtime，我们需要在想要使用runtime的方法或者属性前面加上dynamic关键字。
    @objc dynamic func methodOne(){
        print("我是方法一")
    }
    @objc dynamic func methodTwo(){
        print("我是方法二")
    }
   
}


class RuntimeViewController: UIViewController {
    
    private lazy var funcLabel:UILabel? = {
        
        let xx = UILabel()
        xx.frame = CGRect.init(x: 0, y: 100, width: self.view.bounds.size.width, height: 200)
        xx.textAlignment = .center
        xx.textColor = UIColor.purple
        xx.numberOfLines = 0
        xx.font = UIFont.init(name: "PingFang-SC-Medium", size: 20)
        self.view.addSubview(xx)
        return xx
        
    }()
    
    @objc private dynamic var userGirl:UserModel? = UserModel()
    @objc private dynamic var userBoy:UserModel? = UserModel()
    
    var funcIndex:Int = 0
    var functionStr:String? = ""
    private var functions:[String] = [
        "autoAddProperty","autoInstanceControl","autoAddMethods","autoExchangeTwoMethods","replaceMethod","implementDixToModel"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(clickBack))
        self.title = functionStr
        
        //执行方法；
        let sel:Selector = NSSelectorFromString(self.functions[self.funcIndex])
        self.performSelector(onMainThread: sel, with: nil, waitUntilDone: false)
        self.funcLabel?.text = "执行:" + self.functions[self.funcIndex]
        
    }
    
    @objc private func clickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //动态添加一个属性，读取添加的属性的值
    @objc private func autoAddProperty(){
        
        objc_setAssociatedObject(self, "titleName", "HelloWorld", objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        guard let titleStr = objc_getAssociatedObject(self, "titleName") else { return }
        print(titleStr)
      
    }
    
    //动态变量控制
    @objc private func autoInstanceControl(){
        
        self.userGirl?.isGirl = true
        //修改某一个成员变量的属性的值；
        RuntimeEx.class_changePropertyValue(self.userGirl, propertyName: "isGirl", value: false)
        print("她是一个:",((self.userGirl?.isGirl)! ?"女生":"男生"))
        
    }
    //动态添加方法
    @objc private func autoAddMethods(){
        
        RuntimeEx.class_addMethod(self.userGirl?.classForCoder, methodCls: self.classForCoder, method: #selector(self.run), varStr: "v@")
        //动态添加方法：
        if (self.userGirl?.responds(to: NSSelectorFromString("run")))! {
//            let _ = self.userGirl?.perform(NSSelectorFromString("run"))
            RuntimeEx.objc_sendClass(self.userGirl as Any, andMethod: NSSelectorFromString("run"))
        }
      
    }
    
    @objc private func run(){
        print("I am Running...")
    }
    
    @objc private func walk(){
        print("I am Walking...")
    }
    
    //动态交换两个方法的实现
    @objc private func autoExchangeTwoMethods(){
        RuntimeEx.class_exchangeTwoMethods(self.userGirl, methodOne: #selector(self.userGirl?.methodOne), twoInstance: self, methodTwo: #selector(self.exchangeTwoMethod))
        self.userGirl?.methodOne()
        
    }
    
    @objc private func exchangeTwoMethod(){
        print("交换了两个方法")
    }
    
    //动态拦截并替换方法(在方法上增加额外功能)
    @objc private func replaceMethod(){
        
        RuntimeEx.class_replaceMethod(self.userGirl, methodOne: #selector(self.userGirl?.methodOne), twoInstance: self, methodTwo: #selector(self.replaceFunc))
        self.userGirl?.methodOne()
        
    }
    
    @objc dynamic private func replaceFunc(){
        print("动态拦截并替换方法(在方法上增加额外功能)")
    }
    
    //实现字典转模型的自动转换
    @objc private func implementDixToModel(){
        let dict:[String : Any] =
            [
                "name" : "Jay Zhou",
                "isGirl": true,
                "address":"复旦大学"
        ]
        
        let info:UserModel = UserModel.init(dic:dict)
        print(info.name ?? "" , info.isGirl ?? false , info.address ?? "")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
