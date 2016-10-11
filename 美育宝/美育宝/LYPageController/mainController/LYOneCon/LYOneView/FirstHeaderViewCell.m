//
//  FirstHeaderViewCell.m
//  美育宝
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "FirstHeaderViewCell.h"
//#import "WJScrollImageView.h"

@implementation FirstHeaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(NSArray *)obj
{
    NSInteger conut = obj.count;
    
    // 设置边缘不能弹跳
    self.scroll.bounces = NO;
    
    // 设置滚动视图整页滚动
    self.scroll.pagingEnabled = YES;
    
    // 设置水平滚动条不可见
    self.scroll.showsHorizontalScrollIndicator = NO;
    
    // 设置滚动视图的可见区域
    self.scroll.frame = self.frame;
    
    // 设置contentSize
    self.scroll.contentSize = CGSizeMake(self.scroll.bounds.size.width*conut, self.scroll.bounds.size.height);
    
    // 添加子视图
    for (NSInteger i=0; i<conut; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(self.scroll.bounds.size.width*i, 0, self.scroll.bounds.size.width, self.scroll.bounds.size.height);
        
        NSString *fileName = [NSString stringWithFormat:@"art_sub0%ld.png",i+1];
        imageView.image = [UIImage imageNamed:fileName];
        [self.scroll addSubview:imageView];
        
    }
    
    //设置圆点的个数
    _pageControl.numberOfPages = 4;
    
    //设置圆点的颜色
    _pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    //设置选中的圆点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    //设置圆点不能与用户交互
    _pageControl.userInteractionEnabled = NO;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取滚动位置的偏移量
    CGPoint point = scrollView.contentOffset;
    //计算偏移量是滚动视图宽度的整数倍
    //为了在超过一半时，就自动是下一个圆点
    //通过round函数四舍五入即可
    self.pageControl.currentPage = round(point.x/scrollView.bounds.size.width);
}

@end
