//
//  NewPassWordController.h
//  美育宝
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPassWordController : UIViewController

//@class login;
@property(nonatomic,strong)NSMutableDictionary* dict;
//@property(nonatomic,copy) login *logininfo;

//从a传值到b  属性必须定义在.h文件中
@property(nonatomic,strong)NSString *userPhone;


@end
