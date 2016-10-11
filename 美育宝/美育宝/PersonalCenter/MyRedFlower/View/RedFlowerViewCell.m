//
//  RedFlowerViewCell.m
//  美育宝
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "RedFlowerViewCell.h"
#import "RedFlower.h"

@implementation RedFlowerViewCell
{
    NSString *goldStudyNum;
    NSString *silverStudyNum;
    NSString *bronzeStudyNum;
    
    NSString *goldName;
    NSString *silverName;
    NSString *bronzeName;
}

-(void)setTableViewCellModel:(RedFlower *)obj
{
   
    
    
    self.firstNameLb.text = obj.firstName;
    self.secondNameLb.text = obj.secondName;
    self.thirdNameLb.text  = obj.thirdName;
    
    //学号
    goldStudyNum = obj.firstGroupName;
    silverStudyNum = obj.secondGroupName;
    bronzeStudyNum = obj.thirdGroupName;
//    姓名
    goldName   = obj.firstName;
    silverName = obj.secondName;
    bronzeName = obj.thirdName;
    
    [self.goldBtn addTarget:self action:@selector(goldBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.silverBtn addTarget:self action:@selector(silverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bronzeBtn addTarget:self action:@selector(bronzeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goldBtnClick
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:goldStudyNum forKey:@"gold"];
    [dict setValue:goldName forKey:@"goldname"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"GOLDCLICK" object:nil userInfo:dict]];
}

- (void)silverBtnClick
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:silverStudyNum forKey:@"silver"];
    [dict setValue:silverName forKey:@"silvername"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SILVERCLICK" object:nil userInfo:dict]];
}

- (void)bronzeBtnClick
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:bronzeStudyNum forKey:@"bronze"];
    [dict setValue:bronzeName forKey:@"bronzename"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"BRONZECLICK" object:nil userInfo:dict]];
}

@end
