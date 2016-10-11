//
//  MYWeiDuIntroduceController.m
//  美育宝
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYWeiDuIntroduceController.h"

@interface MYWeiDuIntroduceController ()

@property (weak, nonatomic) IBOutlet UIWebView *weiduWebView;



@end

@implementation MYWeiDuIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gzweidu.com/content.php?AC=about"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];
    self.weiduWebView.scalesPageToFit = YES;
    [self.weiduWebView loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
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
