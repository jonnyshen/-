//
//  hotCollectionViewCell.m
//  Page Demo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "hotCollectionViewCell.h"
#import "HotClassModal.h"
#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation hotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(HotClassModal *)obj
{
    self.title.text = obj.title;
    self.classes.text = [NSString stringWithFormat:@"%@/%@",obj.classesEnd, obj.classesNum];
    
    self.imgUrl.layer.cornerRadius = 8;
    self.imgUrl.layer.masksToBounds = YES;
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imageStr = [tools sendFileString:@"HotClass.plist" andNumber:0];
    if ([obj.imgUrl isKindOfClass:[NSNull class]]) {
        self.imgUrl.image = [UIImage imageNamed:@"loading"];
    } else {
        
        NSString *pieceString = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceString, obj.imgUrl];
        
        [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
   
}

@end
