//
//  MYExerciseViewController.m
//  Page Demo
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYExerciseViewController.h"
#import "MYExerciseTableCell.h"
#import "FirstTableViewCellModal.h"
#import "ExerciseModel.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "MYExerciseDetailController.h"


#define kExerciseURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=gethdlist&pagesize=100&pageindex=1"

@interface MYExerciseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *runArr;
@property (nonatomic, strong) NSString *html_link;

@end

@implementation MYExerciseViewController
{
    NSString *_exerciseID;
}
- (NSMutableArray *)runArr
{
    if (!_runArr) {
        _runArr = [[NSMutableArray alloc] init];
    }
    return _runArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"学校活动";
    
    [self setUpTableView];
    
    [self getExerciseData];
    
    [self.tableView headerBeginRefreshing];
    [self.tableView addHeaderWithTarget:self action:@selector(getExerciseData)];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
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
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
   
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MYSchoolTableCell" bundle:nil] forCellReuseIdentifier:@"MYSchoolTableCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.runArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYSchoolTableCell";
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (self.runArr.count > 0) {
        ExerciseModel *model = self.runArr[indexPath.row];
        [cell setTableViewCellModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExerciseModel *exerModel = self.runArr[indexPath.row];
    _exerciseID = exerModel.exerciseID;
    
//    MYToolsModel *tools = [MYToolsModel new];
//    [tools saveToPlistWithPlistName:@"ExerciseID.plist" andData:_exerciseID];
    
    MYExerciseDetailController *detail = [[MYExerciseDetailController alloc]initWithExerciseID:_exerciseID andhtmlLink:self.html_link];

    [self.navigationController pushViewController:detail animated:YES];
}

- (void)getExerciseData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kExerciseURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            return;
        }
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        
        NSString *imageUrl = responseObject[@"imgurl"];
        
        [tools saveToPlistWithPlistName:@"image.plist" andData:imageUrl];
        
        self.html_link = responseObject[@"infourl"];
        
        self.runArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
           ExerciseModel * model = [[ExerciseModel alloc] init];
            NSString *campName = dic[@"HDMC"];
            if ([campName isKindOfClass:[NSNull class]]) {
                 campName = @" ";
            } else {
                model.partyName = dic[@"HDMC"];
            }
            NSString *begin = dic[@"KSSJ"];
            if ([begin isKindOfClass:[NSNull class]]) {
                model.partyTime =@" ";
            } else {
                model.partyTime = begin;
            }
            NSString *campPhoto = dic[@"HDZP"];
            if ([campPhoto isKindOfClass:[NSNull class]]) {
                model.imageStr = @"160405134632385.jpg";
            } else {
                model.imageStr = campPhoto;
            }
            model.partyDetail  = dic[@"HDCYR"];
            
            model.exerciseID = dic[@"HDID"];
            [self.runArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
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
