//
//  MYWelcomeController.m
//  Page Demo
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYWelcomeController.h"
#import "LYMainViewController.h"

@interface MYWelcomeController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation MYWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupScrollView];
    [self setupPageControl];
}

// 定制滚动视图
-(void)setupScrollView
{
    // 创建滚动视图
    UIScrollView *sv = [[UIScrollView alloc]init];
    
    // 为了捕获滚动视图与用户的交互，需要设置代理
    sv.delegate = self;
    
    // 设置边缘不能弹跳
    sv.bounces = NO;
    
    // 设置滚动视图整页滚动
    sv.pagingEnabled = YES;
    
    // 设置水平滚动条不可见
    sv.showsHorizontalScrollIndicator = NO;
    
    // 设置滚动视图的可见区域
    sv.frame = self.view.frame;
    
    // 设置contentSize
    sv.contentSize = CGSizeMake(sv.bounds.size.width*4, sv.bounds.size.height);
    
    // 添加子视图
    for (NSInteger i=0; i<4; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(sv.bounds.size.width*i, 0, sv.bounds.size.width, sv.bounds.size.height);
        
        NSString *fileName = [NSString stringWithFormat:@"welcome%ld.png",i+1];
        imageView.image = [UIImage imageNamed:fileName];
        [sv addSubview:imageView];
        
        //如果是最后一幅图片，则向其中添加一个按钮
        if (i==3) {
            [self setupEnterButton:imageView];
        }
    }
    // 添加滚动视图到控制器的view中
    [self.view addSubview:sv];
}

// 定制屏幕下方的圆点
-(void)setupPageControl
{
    //创建pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    
    //设置frame
    pageControl.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 30);
    
    //设置圆点的个数
    pageControl.numberOfPages = 4;
    
    //设置圆点的颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    //设置选中的圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    //设置某个圆点被选中
    //pageControl.currentPage = 3;
    
    //设置圆点不能与用户交互
    pageControl.userInteractionEnabled = NO;
    
    //添加到控制器的view中，盖在滚动视图之上
    [self.view addSubview:pageControl];
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

// 配置点击进入程序的按钮
-(void)setupEnterButton:(UIImageView *)iv
{
    //打开iv的用户交互功能,按钮才能响应点击
    iv.userInteractionEnabled = YES;
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake((iv.bounds.size.width-100)/2, iv.bounds.size.height*0.6, 100, 40);
    //button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"进入应用" forState:UIControlStateNormal];
    //配置按钮的边缘
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.cornerRadius = 10;
    
    //增加点击事件
    [button addTarget:self action:@selector(clickEnterAppButton:) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:button];
}

// 点击进入按钮，推出主界面
-(void)clickEnterAppButton:(UIButton *)btn
{
    LYMainViewController *mainVC = [[LYMainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    //更换window的根视图为mainVC
    //欢迎界面不再是根视图以后，就会被系统回收
    
    //获取在main函数中创建过的那个唯一的应用程序对象
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    
    //更换根vc
    window.rootViewController = nav;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
