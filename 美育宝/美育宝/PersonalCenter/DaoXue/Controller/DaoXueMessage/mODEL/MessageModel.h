//
//  MessageModel.h
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, strong) NSString *titleMessage;
@property (nonatomic, strong) NSString *messageDetail;
@property (nonatomic, strong) NSString *pictureString;
@property (nonatomic, assign) NSString * isPost;
@end
