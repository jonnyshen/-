//
//  TRCommentModel.h
//  Page Demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCommentModel : NSObject
//视频播放评论

//图片路径
@property (nonatomic, copy)NSString *imageUrl;
//评论人
@property (nonatomic, copy)NSString *teacherName;
//评论时间
@property (nonatomic, copy)NSString *time;
//评论内容
@property (nonatomic, copy)NSString *detailComment;
//评论等级
@property (nonatomic, copy)NSString *rank;
//评论ID
@property (nonatomic, copy)NSString *commentId;


@end
