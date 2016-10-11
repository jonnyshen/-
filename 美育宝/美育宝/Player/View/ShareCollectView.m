//
//  ShareCollectView.m
//  美育宝
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ShareCollectView.h"

@implementation ShareCollectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    [self.shareBtn addTarget:self action:@selector(shareBtnclick) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)shareBtnclick
{
    NSLog(@"-------------");
}

@end
