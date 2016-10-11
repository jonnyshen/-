//
//  DXPictureViewCell.m
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DXPictureViewCell.h"
#import "PictureSourceModel.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"

@implementation DXPictureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(PictureSourceModel *)obj
{
    self.mesLb.text = obj.pictureName;
    if (obj.pictureString.length > 6) {
        [self downLoadingImage:obj.pictureString];
    } else {
        self.pictureView.image = [UIImage imageNamed:@"002.jpg"];
    }
}

- (void)downLoadingImage:(NSString *)pictureString
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"DXMessagePicture.plist" andNumber:0];
    
    NSString *cutIndexStr = [pictureString substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, pictureString];
    NSLog(@"%@",imageUrl);
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
}

@end
