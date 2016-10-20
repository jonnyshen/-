//
//  HomeWorkStateController.m
//  美育宝
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "HomeWorkStateController.h"
#import "AFNetworking.h"
#import "HomeWorkModel.h"
#import "HomeWorkCell.h"
#import "MYToolsModel.h"
#import "FormValidator.h"

@interface HomeWorkStateController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_dxid;
    NSString *_classID;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homeArray;


@end

@implementation HomeWorkStateController

- (NSMutableArray *)homeArray
{
    if (!_homeArray) {
        _homeArray = [[NSMutableArray alloc] init];
    }
    return _homeArray;
}

- (instancetype)initWithDxid:(NSString *)dxid andClassNumber:(NSString *)classID
{
    if (self = [super init]) {
        _dxid    = dxid;
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"提交详情";
    
    [self getStudentMessage];
    
    [self setUpTableView];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
}

- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.tableView = table;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeWorkCell" bundle:nil] forCellReuseIdentifier:@"HomeWorkCell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeWorkCell" forIndexPath:indexPath];
    HomeWorkModel *homeModel = self.homeArray[indexPath.row];
//    cell.homeWOrkList = homeModel;
    
    if (self.homeArray.count > 0) {
        [cell setHomeWorkCellModel:homeModel];
    }
    
    [cell.remindButton addTarget:self action:@selector(remindStudentFinishHomeWork:) forControlEvents:UIControlEventTouchUpInside];
    [cell.remindButton setTag:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) getStudentMessage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *home_Work_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getdxwctj&dxid=%@&bh=%@",_dxid, _classID];
    
    [manager GET:home_Work_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (self.homeArray) {
            [self.homeArray removeAllObjects];
        }
        
        for (NSDictionary *dictor in responseObject[@"data"]) {

            HomeWorkModel *homeModel = [HomeWorkModel homeWorkDataWithDict:dictor];
            
            [self.homeArray addObject:homeModel];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"----------------------");
    }];
    });
}

- (void)remindStudentFinishHomeWork:(id)index
{
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *teacher_User_Code = [tools sendFileString:@"LoginData.plist" andNumber:2];
    
    HomeWorkModel *homeModel = self.homeArray[[index tag]];
    
    NSString *tips = [NSString stringWithFormat:@"%@请按时完成作业！",homeModel.studentName];
    
    NSString *remindUrl = [[NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savedxtx&txnr=%@&lscode=%@&xscode=%@",tips,teacher_User_Code, homeModel.studentID] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@",remindUrl);
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:remindUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([[responseObject objectForKey:@"issuccess"] isEqualToString:@"true"]) {
            [FormValidator showAlertWithStr:[NSString stringWithFormat:@"已提醒%@",homeModel.studentName]];
        }
        if ([[responseObject objectForKey:@"issuccess"] isEqualToString:@"false"] || [[responseObject objectForKey:@"data"] isEqualToString:@"已提醒过！"]) {
            [FormValidator showAlertWithStr:@"已提醒过TA了"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

@end
