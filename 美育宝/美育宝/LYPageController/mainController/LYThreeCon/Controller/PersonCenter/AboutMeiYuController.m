//
//  AboutMeiYuController.m
//  美育宝
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "AboutMeiYuController.h"

@interface AboutMeiYuController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AboutMeiYuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于美育网络资源共享平台";
    
    NSURL *urlString = [NSURL URLWithString:@"http://art-learn.com/AppPerson/XinWenGongGao/XinWenMingXi.aspx?newsid=7&lb=058003"];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    
    [self.webView loadRequest:request];
    
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
