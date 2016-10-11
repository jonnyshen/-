//
//  MYCollectionViewCell.m
//  Page Demo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation MYCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(MYCellModal *)obj
{
    self.title.text = obj.title;
    //self.subTitle.text = obj.subTitlt;
    //self.free.text = obj.free;
    self.imgUrl.layer.masksToBounds = YES;
    self.imgUrl.layer.cornerRadius = 8;
    if ([obj.imgUrl isEqualToString:@""] || [obj.imgUrl isKindOfClass:[NSNull class]]) {
        self.imgUrl.image = [UIImage imageNamed:@"003.jpg"];
    } else {
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imageStr = [tools sendFileString:@"Three.plist" andNumber:0];
    NSString *pieceString = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, obj.imgUrl];
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
}



@end
