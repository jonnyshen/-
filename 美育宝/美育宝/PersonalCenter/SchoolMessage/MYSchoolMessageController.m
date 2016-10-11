//
//  MYSchoolMessageController.m
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSchoolMessageController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYSchool.h"
#import "FirstTableViewCellModal.h"
#import "MYToolsModel.h"
#import "MessageDetailController.h"
#import "MYSchoolTableCell.h"


#define kTableViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

#define kSchoolMessageUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxwgglist&pagesize=10&pageindex=1&lb=&relationcode="

@interface MYSchoolMessageController ()<UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate>
{
    NSString *imageStr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *schoolArr;
@property (nonatomic, strong) NSMutableArray *teacherArr;
@property (nonatomic, strong) NSMutableArray *messageTypeArr;


@end

@implementation MYSchoolMessageController

- (NSMutableArray *)schoolArr
{
    if (!_schoolArr) {
        _schoolArr = [[NSMutableArray alloc] init];
    }
    return _schoolArr;
}

- (NSMutableArray *)teacherArr
{
    if (!_teacherArr) {
        _teacherArr = [[NSMutableArray alloc] init];
    }
    return _teacherArr;
}
- (NSMutableArray *)messageTypeArr
{
    if (!_messageTypeArr) {
        _messageTypeArr = [[NSMutableArray alloc] init];
    }
    return _messageTypeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
   
    self.title = @"学校公告";
    
    [self setUpTableView];

    
    
     [self schoolDataHttpRequest];
    
    [self.tableView headerBeginRefreshing];
    [self.tableView addFooterWithTarget:self action:@selector(schoolDataHttpRequest)];
}

- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:kTableViewFrame style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    //self.tableView.backgroundColor = [UIColor blueColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MYSchoolTableCell" bundle:nil] forCellReuseIdentifier:@"MYSchoolTableCell"];
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.schoolArr.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.schoolArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYSchoolTableCell";
    
//    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    MYSchoolTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.schoolArr.count > 0) {
        MYSchool *school = self.schoolArr[indexPath.row];
        //MYSchool *school = [MYSchool new];
//        [cell setTableViewCellModel:school];
        cell.schoolList = school;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MYSchool *school = self.schoolArr[indexPath.row];
    
    
//    NSLog(@"%@",school.teacher);
    
    MessageDetailController *messageDetail = [[MessageDetailController alloc] initWithNewsID:school.campUrl];
    messageDetail.title = school.campTitle;
    [self.navigationController pushViewController:messageDetail animated:YES];
    
}

- (void)schoolDataHttpRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
     NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    NSString *schoolMessageUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxwgglist&pagesize=1000&pageindex=1&lb=&relationcode=%@",relationCode];
//        NSLog(@"%@",schoolMessageUrl);
        /*
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:schoolMessageUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//        NSError *error;
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
            
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\s" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\v" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\a" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\e" withString:@""];
            
            
            NSData *replacedata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:replacedata options:NSJSONReadingMutableLeaves error:&error];
//            NSLog(@"%@",dict);
            
            MYToolsModel *tools = [[MYToolsModel alloc] init];
            imageStr = [dict objectForKey:@"imgurl"];
            [tools saveToPlistWithPlistName:@"SchoolMessage.plist" andData:imageStr];
            
            if ([dict[@"data"] isKindOfClass:[NSString class]]) {
                
                return;
            }
            
            self.schoolArr = [NSMutableArray array];
            for (NSDictionary *params in dict[@"data"]) {
                MYSchool *school = [[MYSchool alloc] init];
                school.imageString = params[@"SYZSPic"];
                school.campTitle = params[@"XWBT"];
                school.detail    = params[@"XWNR"];
                school.teacher = params[@"UerName"];
                
                [self.teacherArr addObject:params[@"UerName"]];
                [self.messageTypeArr addObject:params[@"ZDMC"]];
                
                school.times = params[@"FBSJ"];
                school.campDetail    = params[@"ZDMC"];
                [self.schoolArr addObject:school];
            }
//            NSLog(@"--->>>%@",self.schoolArr);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
                
            });
            
            
        }];
        
        [dataTask resume];
        */
        
        
        
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager GET:schoolMessageUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
          
            self.schoolArr = [NSMutableArray array];
            for (NSDictionary *params in responseObject[@"data"]) {
                MYSchool *school = [[MYSchool alloc] initWithSchoolNewsDict:params];

                [self.schoolArr addObject:school];
            }
//            NSLog(@"--->>>%@",self.schoolArr);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
                
            });
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"网络出错%@",error.userInfo);
        }];
        
        
        
        
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
