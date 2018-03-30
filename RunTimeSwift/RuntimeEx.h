//
//  Runtime+(SD).h
//  RunTimeSwift
//
//  Created by qwer on 2018/3/30.
//  Copyright © 2018年 qwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeEx : NSObject

/**
 动态改变某一个成员变量的属性的值；

 @param instance 成员变量
 @param name 成员变量的属性名称
 @param value 要赋的值
 */
+(void)class_changePropertyValue:(id)instance propertyName:(NSString *)name value:(id)value;

/**
 动态添加方法；
 @param cls :  成员变量的类名
 @param selClass 动态添加方法，方法所在的类名
 @param selector 动态添加的方法
 @param varStr 参数符号：@“v@”
 */
+(void)class_addMethod:(Class)cls methodCls:(Class)selClass method:(SEL)selector varStr:(NSString *)varStr;

/**
 动态交换两个方法的实现

 @param instance 类或者成员变量
 @param oneSel 方法一
 @param twoSel 方法二：交换方法一和方法二的实现
 */
+(void)class_exchangeTwoMethods:(id)instance methodOne:(SEL)oneSel methodTwo:(SEL)twoSel;

/**
 动态拦截并替换方法

 @param instance 类或者成员变量
 @param oneSel 方法一
 @param twoSel 使用方法二替换方法一的实现
 */
+(void)class_replaceMethod:(id)instance methodOne:(SEL)oneSel methodTwo:(SEL)twoSel;

/**
 动态执行方法

 @param cls 对象或者类
 @param selector 对象方法或者类方法
 */
+(void)objc_sendClass:(id)cls andMethod:(SEL)selector;


@end
