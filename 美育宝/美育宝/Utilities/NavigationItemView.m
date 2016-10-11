//
//  NavigationItemView.m
//  Page Demo
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "NavigationItemView.h"
#import "Masonry.h"
#import "UIImageView+TRRoundimage.h"

@implementation NavigationItemView

-(instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        UIImageView* imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"user_head.png"];
        [imageV setRoundImageView];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(btn);
        }];
        
        [btn addSubview:imageV];
        
        
        UISearchBar *searchBar = [[UISearchBar alloc]init];
        searchBar.layer.cornerRadius = 18;
        searchBar.layer.masksToBounds = YES;
        searchBar.placeholder =@"美育宝";
        UIView *lastView = [UIView new];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastView.mas_right);
            make.right.mas_equalTo(20);
            make.top.bottom.mas_equalTo(5);
        }];
        lastView = btn;
        [self addSubview:searchBar];
    }
    return self;
}


@end
