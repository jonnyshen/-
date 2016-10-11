//
//  LYTwoViewController.m
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYTwoViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "Masonry.h"

#define SCREEN_WIDTH   CGRectGetWidth([UIScreen  mainScreen].bounds)
#define SCRENN_HEIGHT  CGRectGetHeight([UIScreen mainScreen].bounds)
#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width
#define kNavigationFrame self.navigationController.view.frame
#define kPageCount 3
#define kButton_H 90 //90
#define kMrg 0
#define kTag 100

@interface LYTwoViewController ()<UIScrollViewDelegate>



@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIView *pageLine;
@property (nonatomic, assign)NSInteger currentPages;
@property (nonatomic, strong)NSArray *imageArr;

@property (nonatomic, strong) FirstViewController *first;
@property (nonatomic , strong) SecondViewController *second;
@property (nonatomic , strong) ThreeViewController *three;




@end

@implementation LYTwoViewController

- (NSArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = @[@"schoolClass.png", @"openClass.png", @"sourseCenter.png"];
    }
    return _imageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor lightTextColor];
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    
    //设置分页按钮
    [self setupPageButton];
    
    
    
}

//屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}



/**
 *  设置不可以左右滑动的ScrollView
 */
- (void)setupScrollView{
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kButton_H + 5, kView_W, kView_H)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    //方向锁
    _scroll.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll.scrollEnabled = NO;
    _scroll.contentSize = CGSizeMake(kView_W * 2, kView_H);
    
    [self.view addSubview:_scroll];
}

/**
 *  设置控制的每一个子控制器
 */
- (void)setupChildViewControll{
    self.first = [[FirstViewController alloc]init];
    self.second = [[SecondViewController alloc]init];
    self.three = [[ThreeViewController alloc] init];
//    self.first = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FirstViewController"];
    
    //指定该控制器为其子控制器
    [self addChildViewController:_first];
    [self addChildViewController:_second];
    //[self addChildViewController:_three];
    
    //将视图加入ScrollView上
    [_scroll addSubview:_first.view];
    [_scroll addSubview:_second.view];
    //[_scroll addSubview:_three.view];
    
    //设置两个控制器的尺寸
    //_three.view.frame = CGRectMake(kView_W * 2, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _second.view.frame = CGRectMake(kView_W, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _first.view.frame = CGRectMake(0, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    
}
/**
 *  设置分页按钮
 */
- (void)setupPageButton{
    //button的index值应当从0开始
    UIButton *btn = [self setupButtonWithTitle:@"" imageName:self.imageArr[0] Index:0];
    self.selectBtn = btn;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [self setupButtonWithTitle:@"" imageName:self.imageArr[1] Index:1];
    [self setupButtonWithTitle:@"" imageName:self.imageArr[2] Index:2];
}


- (UIButton *)setupButtonWithTitle:(NSString *)title imageName:(NSString *)imageName Index:(NSInteger)index{
    CGFloat y = 0;
    CGFloat w = (kView_W - kMrg * 3)/kPageCount;
    CGFloat h = kButton_H;
    CGFloat x = kMrg + index * w;
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setTitle:title forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(x, y, w, h);
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    [btn addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(btn);
        make.centerY.mas_equalTo(btn);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    btn.tag = index + kTag;
    
    [btn addTarget:self action:@selector(pageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return btn;
}
- (void)pageClick:(UIButton *)btn{
    
    if (btn.tag == 102) {
        ThreeViewController *three = [[ThreeViewController alloc] init];
        [self.navigationController pushViewController:three animated:YES];
    }
    
    self.currentPages = btn.tag - kTag;
    [self gotoCurrentPage];
}
/**
 *  设置选中button的样式
 */
- (void)setupSelectBtn{
    UIButton *btn = [self.view viewWithTag:self.currentPages + kTag];
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    
    self.selectBtn = btn;
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    //self.pageLine.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame));
}
/**
 *  进入当前的选定页面
 */
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * self.currentPages;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    [_scroll scrollRectToVisible:frame animated:YES];
}


#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scroll.frame.size.width;
    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    
    //设置选中button的样式
//    [self setupSelectBtn];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





//- (void)setHeaderImageView
//{
//    for (int i = 0; i < self.imageArr.count; i ++) {
//        
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageArr[i]]];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(60, 60));
//    }];
//    }
//}



@end
