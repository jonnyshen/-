//
//  TRTitltSearchView.m
//  SlideNav
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 赵贺. All rights reserved.
//

#import "TRTitltSearchView.h"
#import "UIImageView+TRRoundimage.h"

@implementation TRTitltSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
//        UIImageView *backGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_l"]];
//        backGround.frame = frame;
//        [self addSubview:backGround];
        
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(frame.origin.x + 80, frame.origin.y, frame.size.width - 150, frame.size.height)];
        
//        [searchBar setBarStyle:UISearchBarStyleDefault];
        searchBar.layer.cornerRadius = 18;
        searchBar.layer.masksToBounds = YES;
        searchBar.backgroundColor = [UIColor whiteColor];
        [searchBar setPlaceholder:@"大家都在搜：沙画"];
        [self addSubview:searchBar];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"babyImage.jpg"]];
        imageView.frame = CGRectMake(20, 0, 40, 40);
        
        [imageView setRoundImageView];
        
        
        [self addSubview:imageView];
        
        
    }
    return self;
}

@end
