//
//  MYAlertActionController.m
//  美育宝
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYAlertActionController.h"

@interface MYAlertActionController ()

@end

@implementation MYAlertActionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)showAlertControllerWithMessage:(NSString *)message{
    UIAlertController *remindAV = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [remindAV addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:remindAV animated:YES completion:nil];
}
#pragma mark - 网络请求
-(void)getResult{
    //保证输入框不为空
   
    
    
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
