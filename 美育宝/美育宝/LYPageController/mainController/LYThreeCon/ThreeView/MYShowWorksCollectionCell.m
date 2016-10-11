//
//  MYShowWorksCollectionCell.m
//  美育宝
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYShowWorksCollectionCell.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"


@implementation MYShowWorksCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setObj:(MYWorkImage *)obj
{
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = 8;
    
    self.titleLabel.text = obj.title;
    
    if (obj.imageString.length < 13) {
        
    } else {
        NSString *typeStr = [obj.imageString substringWithRange:NSMakeRange(16, 3)];
        
        if ([typeStr isEqualToString:@"png"] || [typeStr isEqualToString:@"jpg"]) {
            
            [self downLoadingImage:obj.imageString];
//             NSLog(@"........>>%@",obj.imageString);
        } else {
            
            if ([obj.videoImage isKindOfClass:[NSNull class]]) {
                self.imageView.image = [UIImage imageNamed:@"001.jpg"];
            } else if ([obj.videoImage isEqualToString:@""]) {
                self.imageView.image = [UIImage imageNamed:@"001.jpg"];
            } else {
                [self downLoadingImage:obj.videoImage];
            }
            
            
        }
    }
}

- (void)setCellModel:(MYWorkImage *)obj
{
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = 8;
    
    self.titleLabel.text = obj.title;
    
    if (obj.imageString.length < 13) {
        
    } else {
        NSString *typeStr = [obj.imageString substringWithRange:NSMakeRange(13, 3)];
        
        if ([typeStr isEqualToString:@"png"] || [typeStr isEqualToString:@"jpg"]) {
            
            [self downLoadingImage:obj.imageString];
           
            
        } else {
            
            if ([obj.videoImage isKindOfClass:[NSNull class]]) {
                self.imageView.image = [UIImage imageNamed:@"001.jpg"];
            } else if ([obj.videoImage isEqualToString:@""]) {
                self.imageView.image = [UIImage imageNamed:@"001.jpg"];
            } else {
                [self downLoadingImage:obj.videoImage];
            }
            
            
        }
    }
    
    
    
}

- (void)downLoadingImage:(NSString *)pictureString
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"Works.plist" andNumber:0];
    
    NSString *cutIndexStr = [pictureString substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, pictureString];

    NSLog(@"---%@",imageUrl);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
}


@end
