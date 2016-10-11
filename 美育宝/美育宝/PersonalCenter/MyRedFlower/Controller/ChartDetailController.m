//
//  ChartDetailController.m
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ChartDetailController.h"
#import "FlowerModel.h"
#import "MyFlowerTableCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "FormValidator.h"

#define TableViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

@interface ChartDetailController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_relationCode;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *flowerArr;

@end

@implementation ChartDetailController

- (NSMutableArray *)flowerArr
{
    if (!_flowerArr) {
        _flowerArr = [[NSMutableArray alloc] init];
    }
    return _flowerArr;
}

- (instancetype)initWithCellId:(NSString *)identify
{
    self = [super init];
    if (self) {
        _relationCode = identify;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    
    [self myFlowerNumberRequest];
    
    [self setTableView];
//    [self.tableView addFooterWithTarget:self action:@selector(myFlowerNumberRequest)];
}

- (void)setTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:TableViewFrame];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyFlowerTableCell" bundle:nil] forCellReuseIdentifier:@"MyFlowerTableCell"];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.flowerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyFlowerTableCell";
    
    MyFlowerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    if (self.flowerArr.count > 0) {
        FlowerModel *flower = self.flowerArr[indexPath.row];
        [cell setTableViewCellModel:flower];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)myFlowerNumberRequest
{
//    MYToolsModel *tools = [[MYToolsModel alloc] init];
//    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    NSString *chartUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyxxhlist&relationcode=%@",_relationCode];
    
    NSLog(@"/=====%@",chartUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:chartUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"XHHJL"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无小红花数据"];
            return;
        } else {
            for (NSDictionary* params in responseObject[@"XHHJL"]) {
                FlowerModel *flower = [FlowerModel flowerModelWithDictionary:params];
//                flower.name = params[@"XM"];
//                flower.winTime = params[@"CJSJ"];
//                flower.teacher = params[@"UserName"];
//                flower.reason = params[@"Memo"];
                [self.flowerArr addObject:flower];
//                NSLog(@"%@",params[@"XM"]);
            }
            [self.tableView reloadData];
//            [self.tableView footerEndRefreshing];
        }
   
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
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
