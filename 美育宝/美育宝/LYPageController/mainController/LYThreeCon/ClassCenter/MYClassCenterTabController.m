//
//  MYClassCenterTabController.m
//  Page Demo
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYClassCenterTabController.h"
#import "MYCourseController.h"
#import "MYNotesController.h"
#import "MYAnswerViewController.h"
#import "MYCollectController.h"

#define KWIDTH ([UIScreen mainScreen].bounds.size.width)
#define KHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Font(num) [UIFont systemFontOfSize:num]

@interface MYClassCenterTabController ()
{
    NSArray     *normalImageArray;
    NSArray     *highlightedImageArray;
    NSArray     *titleArray;
    
    UIImageView *tempImageView;//临时图片
    UILabel     *tempLabel;//临时标签
    UIButton    *tempButton;//临时按钮
    
    NSInteger   index;//记录上次点击的按钮
}
@property (nonatomic,strong)UIView *tabBarBgView;


@end

@implementation MYClassCenterTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTabBarController];
    
    [self configerUI];
    
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
//    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
//    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
//    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    [self.navigationItem setLeftBarButtonItem:addBtn];

}

- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTabBarController
{
    normalImageArray = [[NSArray alloc]initWithObjects:@"1.png",@"2.png",@"3.png",@"5.png", nil];
    highlightedImageArray = [[NSArray alloc]initWithObjects:@"12.png",@"22.png",@"32.png",@"52.png", nil];
    titleArray = [[NSArray alloc]initWithObjects:@"我的课程",@"我的笔记",@"我的问答",@"我的收藏", nil];
    self.title = titleArray.firstObject;
    MYCourseController *course = [[MYCourseController alloc] init];
    course = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"MYCourseController"];
    
    MYNotesController *notes = [[MYNotesController alloc] init];
    notes = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"MYNotesController"];
    
    MYAnswerViewController *answer = [[MYAnswerViewController alloc] init];
    answer = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"MYAnswerViewController"];
    
    MYCollectController *collect = [[MYCollectController alloc] init];
    collect = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"MYCollectController"];
    self.viewControllers = @[course, notes, answer, collect];
}

#pragma mark---配置UI界面
- (void)configerUI{
    
    //背景
    self.tabBarBgView = [[UIView alloc]initWithFrame:CGRectMake(0, KHEIGHT-49, KWIDTH, 49)];
    self.tabBarBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBarBgView];
    
    float interValX = KWIDTH/4-20;
    
    //创建4个按钮
    for (int i = 0; i<4; i++) {
        
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KWIDTH/2-35)/4+(20+interValX)*i, 6, 20, 20)];
        imageView.image = [UIImage imageNamed:normalImageArray[i]];
        imageView.tag = i+200;
        [self.tabBarBgView addSubview:imageView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake((KWIDTH/4)*i, CGRectGetMinY(imageView.frame)+25, KWIDTH/4, 15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(10);
        titleLabel.textColor = RGBA(100, 100, 100, 1);
        titleLabel.text = titleArray[i];
        titleLabel.tag = i+300;
        [self.tabBarBgView addSubview:titleLabel];
        
        //按钮
        UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBtn.frame = CGRectMake((KWIDTH/4)*i, 0, KWIDTH/4, 49);
        [tabBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tabBtn.tag = i+100;
        tabBtn.selected = NO;
        [self.tabBarBgView addSubview:tabBtn];
        
        //第一个默认被选中
        if (i == 0) {
            
            imageView.image = [UIImage imageNamed:highlightedImageArray[0]];
            titleLabel.textColor = [UIColor redColor];
            tabBtn.selected = YES;
        }
    }
}

#pragma mark
#pragma mark---tabBar 按钮点击
- (void)tabBtnClick:(UIButton *)btn{
    
    //第一个不被选中
    UIImageView *img0    = (UIImageView *)[self.view viewWithTag:200];
    UILabel     *lab0    = (UILabel *)[self.view viewWithTag:300];
    UIButton    *button0 = (UIButton *)[self.view viewWithTag:100];
    img0.image = [UIImage imageNamed:normalImageArray[0]];
    lab0.textColor = RGBA(100, 100, 100, 1);
    button0.selected = NO;
    
    //切换VC
    self.selectedIndex = btn.tag-100;
    
    //取反
    btn.selected = !btn.selected;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:btn.tag+100];
    UILabel *label = (UILabel *)[self.view viewWithTag:btn.tag+200];
    
    if (btn.selected == YES) {
        
        //临时图片转换
        tempImageView.image = [UIImage imageNamed:normalImageArray[index]];
        imageView.image = [UIImage imageNamed:highlightedImageArray[btn.tag-100]];
        tempImageView = imageView;
        
        //临时标签转换
        tempLabel.textColor = RGBA(100, 100, 100, 1);
        label.textColor = [UIColor redColor];
        tempLabel = label;
        
        //临时按钮转换
        tempButton.selected = NO;
        btn.selected = YES;
        tempButton = btn;
        
        self.title = titleArray[btn.tag-100];
    }
    
    //记录上次按钮
    index  = self.selectedIndex;
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
