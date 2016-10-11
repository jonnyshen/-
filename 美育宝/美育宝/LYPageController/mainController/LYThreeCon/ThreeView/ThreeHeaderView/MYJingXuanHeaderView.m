//
//  MYJingXuanHeaderView.m
//  美育宝
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYJingXuanHeaderView.h"

@implementation MYJingXuanHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)StudentJingXuanHeaderView
{
    MYJingXuanHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
    return headerView;
}

- (IBAction)StuHeaderViewAction:(UIButton *)sender {
    
    if (self.StudentJingXuanHeaderView) {
        self.StudentJingXuanHeaderView(sender.tag);
    }
    
    
}



@end
