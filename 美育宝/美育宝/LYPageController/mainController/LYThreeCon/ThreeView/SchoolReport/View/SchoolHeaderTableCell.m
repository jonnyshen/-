//
//  SchoolHeaderTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SchoolHeaderTableCell.h"
#import "MYTerms.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"

#define SchoolTerm @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxq"

//static int a = 0;
@implementation SchoolHeaderTableCell
{
    NSInteger a;
}

- (void)setHeaderTableCellModel:(NSString *)obj
{
    // 创建滚动视图
    UIScrollView *sv = [[UIScrollView alloc]init];
    self.sv = sv;
    // 为了捕获滚动视图与用户的交互，需要设置代理
    self.sv.delegate = self;
    
    // 设置边缘不能弹跳
    self.sv.bounces = NO;
    
    // 设置滚动视图整页滚动
    self.sv.pagingEnabled = YES;
    
    // 设置水平滚动条不可见
    self.sv.showsHorizontalScrollIndicator = NO;
    //设置不可以滚动，只能点击按钮滚动
    self.sv.scrollEnabled = NO;
    
    // 设置滚动视图的可见区域
    self.sv.frame = CGRectMake(0, 0, self.frame.size.width, 100);
    
    //获取网络数据
    [self getSchoolTerm];
    
    NSInteger count = self.marksArr.count;
    
    // 设置contentSize
    self.sv.contentSize = CGSizeMake(sv.bounds.size.width*count, 0);
    
    a = 0;
    // 添加子视图
    for (NSInteger i=0; i<count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(sv.bounds.size.width*i, 0, sv.bounds.size.width, sv.bounds.size.height);
        
        NSString *fileName = [NSString stringWithFormat:@"background.png"];
        imageView.image = [UIImage imageNamed:fileName];
        [self.sv addSubview:imageView];
        
       
        
        MYTerms *terms = self.marksArr[i];
        
        //每一张图片，向其中添加2个按钮
        [self setupEnterButton:imageView andClassTerm:terms];
        
        //每一张图片中间添加一个label显示学期名称
        [self setReportName:imageView andClassTerm:terms];
    }
    // 添加滚动视图到控制器的view中
    [self addSubview:self.sv];

}


- (void)setupEnterButton:(UIImageView *)iv andClassTerm:(MYTerms *)terms
{
    //打开iv的用户交互功能,按钮才能响应点击
    iv.userInteractionEnabled = YES;
    
    self.backBtn = [[UIButton alloc]init];
    //self.backBtn.tag = 100;
    self.backBtn.frame = CGRectMake(20, iv.bounds.size.height*0.5 - 30, 60, 60);
    //self.backBtn.backgroundColor = [UIColor redColor];
    [iv addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"button01.png"] forState:UIControlStateNormal];
    
    [self.backBtn addTarget:self action:@selector(lastReport:andClassTerm:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nextBtn = [[UIButton alloc] init];
    //self.nextBtn.tag = 101;
    self.nextBtn.frame = CGRectMake(iv.frame.size.width - 60, iv.bounds.size.height*0.5 - 30, 60, 60);
    //self.nextBtn.backgroundColor = [UIColor redColor];
    [iv addSubview:self.nextBtn];
    [self.nextBtn setImage:[UIImage imageNamed:@"button02.png"] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextReport:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setReportName:(UIImageView *)imageView andClassTerm:(MYTerms *)terms
{
    
    imageView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(imageView.frame.size.width/2 - 125, imageView.frame.size.height * 0.5 - 20, 250, 40);
    
    //label.backgroundColor = [UIColor blueColor];
    [imageView addSubview:label];
    NSString *textName = [NSString stringWithFormat:@"%@",terms.termsName];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:23.0f];
    label.text = textName ;
    
    
    
    
}


- (void)lastReport:(UIButton *)sender andClassTerm:(NSString *)terms
{
    
    if (a == 0) {
        a = self.marksArr.count;
    }
    a--;
    [self.sv setContentOffset:CGPointMake(self.sv.bounds.size.width * a, 0) animated:YES];
    
    NSString *codeNum = [NSString stringWithFormat:@"%ld",a];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:codeNum,@"termsCode", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"HeaderCode" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)nextReport:(UIButton *)sender
{
    a++;
    if (a == self.marksArr.count) {
        a = 0;
    }
    [self.sv setContentOffset:CGPointMake(self.sv.bounds.size.width * a, 0) animated:YES];
    
    NSString *codeNum = [NSString stringWithFormat:@"%ld",a];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:codeNum,@"nextCode", nil];
    NSNotification *notice = [NSNotification notificationWithName:@"HeaderNextCode" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

//获取学期报告
- (void)getSchoolTerm
{
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:SchoolTerm parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            for (NSDictionary *params in responseObject[@"data"]) {
                MYTerms *terms = [[MYTerms alloc] init];
                terms.termsCode = params[@"XQM"];
                terms.beginTime = params[@"XNS"];
                terms.finishTime = params[@"XNE"];
                terms.termsName = params[@"XQ"];
                [self.marksArr addObject:terms];
            }
            //[self.tableView reloadData];
            //[self.tableView headerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
    });  */
    
    NSString *codeUrl = [SchoolTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlString = [NSURL URLWithString:codeUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    for (NSDictionary *params in diction[@"data"]) {
        MYTerms *terms = [[MYTerms alloc] init];
        
        [self.codeArr addObject:params[@"XQM"]];
        
        terms.beginTime = params[@"XNS"];
        terms.finishTime = params[@"XNE"];
        terms.termsName = params[@"XQ"];
        [self.marksArr addObject:terms];
    }
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveDataToPlistWithPlistName:@"TermsCode.plist" andData:self.codeArr];
}



- (NSMutableArray *)marksArr
{
    if (!_marksArr) {
        _marksArr = [[NSMutableArray alloc] init];
    }
    return _marksArr;
}

- (NSMutableArray *)codeArr
{
    if (!_codeArr) {
        _codeArr = [[NSMutableArray alloc] init];
    }
    return _codeArr;
}

@end
