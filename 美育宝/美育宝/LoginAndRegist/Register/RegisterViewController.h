//
//  RegisterViewController.h
//  Page Demo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    KRTeacher = 0,
    KRStudent,
    KRFamily,
    KROther
}RegisterIDType;

typedef enum {
    KRMen = 0,
    KRWemen
}KRSexType;

typedef void(^KRSexBlock)(KRSexType men);

typedef void(^KRRegisterTypeBlock)(RegisterIDType background);

@interface RegisterViewController : UIViewController

@end
