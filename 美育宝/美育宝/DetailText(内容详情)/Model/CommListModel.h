//
//  CommListModel.h
//  Page Demo
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommListModel : NSObject
//图片路径
@property (nonatomic, strong) NSString *imageUrl;
//评论明细
@property (nonatomic , strong) NSString *comment;
//评论人
@property (nonatomic, strong) NSString * teacherName;
//这一条评论的ID
@property (nonatomic , strong) NSString *commentIdentifier;

 
@end
