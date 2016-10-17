//
//  ClassifiedWorksUploadCon.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifiedWorksUploadCon : UIViewController

//点击了高级之后隐藏的九个联动条件按钮
@property (weak, nonatomic) IBOutlet UIView *highView;//放置九个按钮的view
@property (weak, nonatomic) IBOutlet UIButton *highOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *highTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *highThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *highFourBtn;
@property (weak, nonatomic) IBOutlet UIButton *highFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *highSixBtn;
@property (weak, nonatomic) IBOutlet UIButton *highSevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *highEightBtn;
@property (weak, nonatomic) IBOutlet UIButton *hightNineBtn;

@property (weak, nonatomic) IBOutlet UIButton *highUploadBtn;//最后确定上传的按钮

- (instancetype)initWithImageData:(NSString *)imageDataString classDecribe:(NSString *)descrbe;

@end
