//
//  GGRecomGameCell.m
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import "GGMovieCell.h"
#import "ggmovieModel.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation GGMovieCell

- (void)awakeFromNib {
}
-(void)setCellModel:(GGMovieModel *)obj{
    
    
    
    if ([obj.title isKindOfClass:[NSNull class]]) {
        self.title.text = @"";
    } else {
        self.title.text = obj.title;
    }
    
    if ([obj.nickName  isEqual: @""]) {
        self.nickName.hidden = YES;
    }
    self.nickName.text = obj.nickName;
   
    self.imgUrl.layer.cornerRadius = 8;
    self.imgUrl.layer.masksToBounds = YES;
    
    [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:obj.imgUrl] placeholderImage:[UIImage imageNamed:@"loading"]];

    
    
    
}
@end
