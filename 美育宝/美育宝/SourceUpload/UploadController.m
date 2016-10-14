//
//  UploadController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "UploadController.h"
#import "WorksController.h"
#import "SourceController.h"
@interface UploadController ()
@property (weak, nonatomic) IBOutlet UIButton *worksBtn;
@property (weak, nonatomic) IBOutlet UIButton *sourceBtn;

@end

@implementation UploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"上传途径";
    
    [self.worksBtn addTarget:self action:@selector(worksBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sourceBtn addTarget:self action:@selector(sourceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)worksBtnClick
{
    WorksController *works = [[WorksController alloc] init];
    [self.navigationController pushViewController:works animated:YES];
    
}

- (void)sourceBtnClick
{
    SourceController *source = [[SourceController alloc] init];
    
    [self.navigationController pushViewController:source animated:YES];
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
