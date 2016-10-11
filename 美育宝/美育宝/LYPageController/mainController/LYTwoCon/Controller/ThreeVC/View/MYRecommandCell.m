//
//  MYRecommandCell.m
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYRecommandCell.h"
#import "UIImageView+WebCache.h"

#import "MYToolsModel.h"

@implementation MYRecommandCell

- (void)setCollectionViewCellModel:(Recommand *)obj
{
    self.className.text = obj.className;
    
    self.imageUrl.layer.cornerRadius = 8;
    self.imageUrl.layer.masksToBounds = YES;
    if ([obj.imgUrl isKindOfClass:[NSNull class]]) {
        self.imageUrl.image = [UIImage imageNamed:@"003.jpg"];
    } else if (obj.imgUrl.length < 6 ) {
        self.imageUrl.image = [UIImage imageNamed:@"003.jpg"];
    } else {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *imageStr = [tools sendFileString:@"Three.plist" andNumber:0];
        NSString *pieceString = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, obj.imgUrl];
        
        
        [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
}

@end
