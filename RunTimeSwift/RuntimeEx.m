//
//  Runtime+(SD).m
//  RunTimeSwift
//
//  Created by qwer on 2018/3/30.
//  Copyright © 2018年 qwer. All rights reserved.
//

#import <objc/message.h>
#include <objc/runtime.h>
#import "RuntimeEx.h"

@implementation RuntimeEx

//动态改变某一个成员变量的属性的值；
+(void)class_changePropertyValue:(id)instance propertyName:(NSString *)name value:(id)value{
    
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([instance class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        //动态生成的属性名称：
        NSString *proname = [NSString stringWithUTF8String:varName];
        //
        if ([proname isEqualToString:name]) {   //这里别忘了给属性加下划线
            object_setIvar(instance, var, value);
            break;
        }
    }
    
}

//动态添加成员变量方法：
+(void)class_addMethod:(Class)cls methodCls:(Class)selClass method:(SEL)selector varStr:(NSString *)varStr
{
    const char * a =[varStr UTF8String];
    Method md = class_getInstanceMethod([selClass class], selector);
    IMP imp = method_getImplementation(md);
    class_addMethod([cls class], selector, imp, a);

}

//动态交换两个方法的实现
+(void)class_exchangeTwoMethods:(id)instance methodOne:(SEL)oneSel methodTwo:(SEL)twoSel{
    
    Method m1 = class_getInstanceMethod([instance class], oneSel);
    Method m2 = class_getInstanceMethod([instance class], twoSel);
    method_exchangeImplementations(m1, m2);

}

//动态拦截并替换方法
+(void)class_replaceMethod:(id)instance methodOne:(SEL)oneSel methodTwo:(SEL)twoSel{
    
    Class selfClass = [instance class];
    
    Method oriMethod = class_getInstanceMethod(selfClass, oneSel);
    Method cusMethod = class_getInstanceMethod(selfClass, twoSel);
    
    BOOL addSucc = class_addMethod(selfClass, oneSel, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        class_replaceMethod(selfClass, twoSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else {
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    
}

//动态执行方法；
+(void)objc_sendClass:(id)cls andMethod:(SEL)selector{
    
   // objc_msgSend(cls, selector);                    //警告
    ((void (*)(id, SEL))objc_msgSend)(cls, selector); //正确写法
    
}



@end
