//
//  GGListClassCell.m
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import "GGListClassCell.h"
//#import "GGListClassModel.h"
#import "Masonry.h"


#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BtnMargin 0
#define imageBtn 20

@implementation GGListClassCell

- (NSArray *)images{
    if (!_images) {
        _images=@[@"art_sub01.png",@"art_sub02.png",@"art_sub03.png",@"art_sub04.png"];
    }
    return _images;
}
- (NSArray *)titles{
    if (!_titles) {
        
        _titles = @[@"美术",@"书法",@"沙画",@"音乐"];
    }
    return _titles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setCellModel:(NSString *)obj{
    
    //if ([obj isEqualToString:@"B"]) {
        
    
    
    NSInteger count = 4;
    
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(@0);
        }];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
        CGFloat btnWidth = (ScreenWidth - BtnMargin * (count + 1)) / count;
        CGFloat btnHeight = self.bounds.size.height - BtnMargin * 2;
        scrollView.backgroundColor = [UIColor grayColor];
        UIView *view = scrollView;
    for (NSInteger i=0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(10+(ScreenWidth/5+20)*i, 0 , ScreenWidth/5, ScreenWidth/5);
        [scrollView addSubview:btn];
           // 5个间隔 间隔为20;
            //btn的width
        //btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1];
        btn.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(view).with.offset(BtnMargin);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnHeight);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_right).with.offset(BtnMargin);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(btnHeight);
                make.centerY.equalTo(view);
            }];
        }
        view  = btn;
       
        
        //GGListClassModel *model = obj[i];
        
        
//        button中的图片
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 10 , ScreenWidth/7 , ScreenWidth/7)];
        //UIImageView *imageV = [[UIImageView alloc]init];
        imageV.layer.cornerRadius = imageV.frame.size.width/2;
        //[imageV sd_setImageWithURL:[NSURL URLWithString:model.thnumb]];
        imageV.image = [UIImage imageNamed:self.images[i]];
        
        
        [btn addSubview:imageV];
        
        //button中的label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWidth/7+15 , ScreenWidth/5, 20)];
        [btn addSubview:label];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        //label.text = [NSString stringWithFormat:@"%zd",i];
        label.text = self.titles[i];
        
        
    }
        
        
     scrollView.contentSize = CGSizeMake(ScreenWidth/4*count+20, 0);
    
   // }
}
@end
