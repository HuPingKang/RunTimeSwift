//
//  NSObject+Extension.swift
//
//  Created by qwer on 2018/4/2.
//  Copyright © 2018年 qwer. All rights reserved.
//

import Foundation
extension NSObject{
    
    //自定义构造方法
    convenience init(dic: [String:Any]) {
        self.init()
        self.setAttribut(dic: dic)
    }
    
    func setAttribut(dic: [String:Any]) -> Void {
        let attributDic = attributesDic(dic: dic)
        
        //Runtime获取本类属性
        var count:UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        for i in 0..<count {
            //取出属性名
            let ivar = ivars?[Int(i)]
            let ivarName = ivar_getName(ivar!)
            let nName = String(cString: ivarName!)
            //取出要赋值的值
            var attribut = attributDic[nName]
            if attribut == nil{
                attribut = ""
            }
            var value:NSObject
            if dic[attribut!] != nil {
                value = dic[attribut!] as! NSObject
            } else {
                value = "" as NSObject
            }
            
            //利用KVC给本类的属性赋值
            self.setValue(value, forKey: nName)
            
        }
        
    }
    
    //如果属性名与数据字典的key值不对应，那么在子类model中复写此方法，将属性名作为key，字典key值作为value
    func attributesDic(dic: [String:Any]) -> [String:String] {
        
        var newDic:[String:String] = [:]
        
        for key in dic.keys {
            //复写时注意将属性名作为key 数据字典的key作为value
            newDic[key] = key
        }
        
        return newDic
    }

    
}
