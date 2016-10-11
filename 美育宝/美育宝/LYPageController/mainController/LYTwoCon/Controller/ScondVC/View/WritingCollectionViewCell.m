//
//  WritingCollectionViewCell.m
//  Page Demo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "WritingCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation WritingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(WritingModal *)obj
{
    self.title.text = obj.title;
    NSLog(@"---class---%@",[NSString stringWithFormat:@"%@",obj.classes]);
    self.classes.text = obj.classes;
    self.people.text = obj.people;
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imageStr = [tools sendFileString:@"RecommendClass.plist" andNumber:0];
    NSString *pieceString = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, obj.imgUrl];
    self.imgUrl.layer.cornerRadius = 8;
    self.imgUrl.layer.masksToBounds = YES;
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
}

@end
