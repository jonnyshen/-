//
//  LYMainViewController.m
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width
#define kNavigationFrame self.navigationController.view.frame
#define kPageCount 3
#define kButton_H 45
#define kMrg 0
#define kTag 100

#import "LYMainViewController.h"
#import "LYOneViewController.h"
#import "LYTwoViewController.h"
#import "LYThreeViewController.h"
#import "JZSearchBar.h"
#import "TRTitltSearchView.h"
#import "KJCustomButton.h"

#import "NavigationItemView.h"
#import "MYSearchViewController.h"

#import "UIImage+JZ.h"

@interface LYMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIView *pageLine;
@property (nonatomic, assign)NSInteger currentPages;
@property (nonatomic, strong)NSMutableArray *btnsArr;

@property (nonatomic, strong)LYOneViewController *oneVC;
@property (nonatomic, strong)LYTwoViewController *twoVC;
@property (nonatomic, strong)LYThreeViewController *threeVC;

@property (nonatomic, strong)UIButton *leftButton;
//-----------------------------

@end

@implementation LYMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱教育";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.015686 green:0.545098 blue:0.984313 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    
    
    
    //设置分页按钮
    [self setupPageButton];
    
   
    [self setupItems];
    
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//导航栏
- (void)setupItems{
    
//    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Naviheader"]];
//    self.navigationItem.titleView = header;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
//    [barItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = barItem;
    
}

-(void)clickLeftButton {
    MYSearchViewController *search = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    
}

/**
 *  设置可以左右滑动的ScrollView
 */
- (void)setupScrollView{

    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kButton_H + 64, kView_W, kView_H)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    //方向锁
    _scroll.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll.contentSize = CGSizeMake(kView_W * kPageCount, kView_H);
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
}

/**
 *  设置控制的每一个子控制器
 */
- (void)setupChildViewControll{
    
    
    self.oneVC = [[LYOneViewController alloc]init];

    
    self.twoVC = [[LYTwoViewController alloc]init];

    
    self.threeVC = [[LYThreeViewController alloc] init];

    self.twoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LYTwoViewController"];
    self.threeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LYThreeViewController"];

    //指定该控制器为其子控制器
    [self addChildViewController:_oneVC];
    [self addChildViewController:_twoVC];
    [self addChildViewController:_threeVC];
    

//    
    
    //将视图加入ScrollView上
    [_scroll addSubview:_oneVC.view];
    [_scroll addSubview:_twoVC.view];
    [_scroll addSubview:_threeVC.view];
    
    
    
    //设置两个控制器的尺寸
    _threeVC.view.frame = CGRectMake(kView_W * 2, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _twoVC.view.frame = CGRectMake(kView_W, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _oneVC.view.frame = CGRectMake(0, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    
    
}
/**
 *  设置分页按钮
 */
- (void)setupPageButton{
    //button的index值应当从0开始、
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"首页"];
    [arr addObject:@"课程中心"];
    [arr addObject:@"个人中心"];
    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [self setupButtonWithTitle:arr[i] Index:i];
        self.selectBtn = btn;
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    
}

- (UIButton *)setupButtonWithTitle:(NSString *)title Index:(NSInteger)index{
    CGFloat y = 64;
    CGFloat w = (kView_W - kMrg * 3)/kPageCount;
    CGFloat h = kButton_H;
    CGFloat x = kMrg + index * w;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];

    btn.frame = CGRectMake(x, y, w, h);

    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];

    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
    btn.tag = index + kTag;
    
    [btn addTarget:self action:@selector(firstpageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
 
    [self.btnsArr addObject:btn];
    return btn;
}
- (void)firstpageClick:(UIButton *)btn{
    self.currentPages = btn.tag - kTag;
    btn.selected = YES;

    self.selectBtn.selected = YES;
    [self gotoCurrentPage];
}

/*
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
    [self updateView];
}

-(void)updateView{
    for (UIButton *btn in _btnsArr) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont systemFontOfSize:20.0f];
        
        
        if (btn.tag -1==kTag+self.currentPages-1) {
            self.selectBtn = btn;
            btn.selected = YES;
        } else {
            btn.selected = NO;
//            self.selectBtn.selected = NO;
        }
    }
    
    
    
}

- (NSMutableArray *)btnsArr
{
    if (!_btnsArr) {
        _btnsArr = [[NSMutableArray alloc] init];
    }
    return _btnsArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
