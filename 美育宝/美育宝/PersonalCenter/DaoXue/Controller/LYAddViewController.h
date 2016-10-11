//
//  LYAddViewController.h
//  Page Demo
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LYAddViewControllerDelegate <NSObject>

- (void)LYAddViewControllerdidPutBTtext:(NSString *)btText YQtextView:(NSString *)textView postSuccess:(BOOL)success;

@end



@interface LYAddViewController : UIViewController

- (instancetype)initWithTargetPeriodName:(NSString *)period withSender:(NSString *)classNumber materialCode:(NSString *)material periodID:(NSString *)periodid;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIButton *addDaoXueBtn;

@property (nonatomic, weak) id<LYAddViewControllerDelegate>delegate;
@end
