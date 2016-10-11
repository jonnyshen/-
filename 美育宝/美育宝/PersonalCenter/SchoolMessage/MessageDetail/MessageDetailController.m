//
//  MessageDetailController.m
//  美育宝
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MessageDetailController.h"
#import "NoticDetailModel.h"
#import "MessageHeaderCell.h"
#import "FirstTableViewCellModal.h"
#import "AFNetworking.h"

@interface MessageDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_newsID;
}
@property (strong, nonatomic)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *noticArr;

@end

@implementation MessageDetailController

- (instancetype)initWithNewsID:(NSString *)newsID
{
    if (self = [super init]) {
        _newsID = newsID;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title userName:(NSString *)userName imageUrl:(NSString *)imageUrl noticsDetail:(NSString *)detail schoolOrOutside:(NSString *)school noticTimes:(NSString *)times
{
    self = [super init];
    if (self) {
        NoticDetailModel *noticModel = [NoticDetailModel new];
        
        noticModel.campTitle = title;
        noticModel.times     = times;
        noticModel.imageStr  = imageUrl;
        noticModel.teacher   = userName;
        noticModel.detail    = detail;
        noticModel.school    = school;
        [self.noticArr addObject:noticModel];
        
    }
    return self;
}

- (NSMutableArray *)noticArr
{
    if (!_noticArr) {
        _noticArr = [[NSMutableArray alloc] init];
    }
    return _noticArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    if (_newsID) {
//        [self getNewsData];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:webView];
//        webView.scalesPageToFit = YES;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_newsID] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        [webView loadRequest:request];
        
    }
    

}



- (void)initSomeView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView = table;
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageHeaderCell" bundle:nil] forCellReuseIdentifier:@"MessageHeaderCell"];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MessageHeaderCell";
    
    MessageHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    if (self.noticArr.count > 0) {
        cell.noticList = self.noticArr[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height * 1.5f;
}

- (void)getNewsData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *NEWSURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxwgginfo&infoid=%@&type=0&lb=",_newsID];
//        NSLog(@"%@",NEWSURL);
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:NEWSURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\s" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
//            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"    " withString:@""];
            
            NSData *replacedata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:replacedata options:NSJSONReadingMutableLeaves error:&error];
//                        NSLog(@"%@",dict);
            NoticDetailModel *noticModel = [NoticDetailModel noticDataWithDict:dict];
            
            [self.noticArr addObject:noticModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        [task resume];
        
        
    });
    
    
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
