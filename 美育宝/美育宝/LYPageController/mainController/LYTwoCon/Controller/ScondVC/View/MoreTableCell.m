//
//  MoreTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MoreTableCell.h"
#import "ReconmmandModal.h"
#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation MoreTableCell

- (void)setTableViewCellModel:(HotClassModal *)obj
{
    self.image.layer.cornerRadius = 8.0;
    self.image.layer.masksToBounds = YES;
    
    if ([obj.imgUrl isKindOfClass:[NSNull class]]) {
        self.image.image = [UIImage imageNamed:@"001.jpg"];
    } else {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *imageStr = [tools sendFileString:@"HotClass.plist" andNumber:0];
        NSString *pieceString = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, obj.imgUrl];
        
        [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
    
    
    self.title.text = [NSString stringWithFormat:@"%@-%@",obj.title,obj.subtitle];
    self.userName.text = obj.userName;
    self.classNum.text = [NSString stringWithFormat:@"%@/%@", obj.classesEnd, obj.classesNum];
}

- (void)setRecommendTableCell:(ReconmmandModal *)recomm
{
    
    
    self.image.layer.cornerRadius = 8;
    self.image.layer.masksToBounds = YES;
    
    if ([recomm.imgUrl isKindOfClass:[NSNull class]]) {
        self.image.image = [UIImage imageNamed:@"001.jpg"];
    } else {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *imageStr = [tools sendFileString:@"RecommendClass.plist" andNumber:0];
        NSString *pieceString = [recomm.imgUrl substringWithRange:NSMakeRange(0, 6)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, recomm.imgUrl];
        [self.image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }

    
    self.title.text = [NSString stringWithFormat:@"%@-%@",recomm.title,recomm.subtitle];
    self.userName.text = recomm.userName;
    if ([recomm.classesEnd isKindOfClass:[NSNull class]] || [recomm.classesNum isKindOfClass:[NSNull class]]) {
        self.classNum.text = @"0/0";
    } else {
        self.classNum.text = [NSString stringWithFormat:@"%@/%@", recomm.classesEnd, recomm.classesNum];
    }
    
    
}

@end
