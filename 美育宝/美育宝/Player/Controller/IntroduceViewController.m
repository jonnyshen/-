//
//  IntroduceViewController.m
//  Page Demo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "IntroduceViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "IntroDetail.h"
#import "introduceModel.h"
#import "IntroduceTableViewCell.h"
#include "DetailTableViewCell.h"
#import "FirstTableViewCellModal.h"
#import "LYOneViewController.h"
#import "LoginViewController.h"


#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height

#define kAddViewX kView_H - 20 - 200 - 70 - 49

@interface IntroduceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *introArr;
@property (strong, nonatomic) NSMutableArray *detailArr;
@property (strong, nonatomic) NSMutableDictionary *dataDic;
@property (strong, nonatomic) NSString *playerId;


@end

@implementation IntroduceViewController

- (NSMutableArray *)introArr
{
    if (!_introArr) {
        _introArr = [[NSMutableArray alloc] init];
    }
    return _introArr;
}
- (NSMutableArray *)detailArr
{
    if (!_detailArr) {
        _detailArr = [[NSMutableArray alloc] init];
    }
    return _detailArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self httpRequest];
    
    [self setUpTableView];
    
    [self.tableView headerBeginRefreshing];
    
    
    
}



- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kAddViewX);
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntroduceTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
}

#pragma mark - UITbaleViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.detailArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = @"IntroduceTableViewCell";
    } else {
        cellID = @"DetailTableViewCell";
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    if (indexPath.section == 0) {
        if (self.introArr.count > 0) {
            introduceModel *introduce = self.introArr[indexPath.row];
            //introduceModel * introduce = [introduceModel new];
            [cell setTableViewCellModel:introduce];
        }
        
    } else {
        if (self.detailArr.count > 0) {
            IntroDetail *detail = self.detailArr[indexPath.row];
            //IntroDetail * detail = [IntroDetail new];
            [cell setTableViewCellModel:detail];
        }
    }
    return cell;
    
    
    
    
}
-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 300;
    }
    return 150;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (void)LYOneViewControllergetPlayerId:(NSString *)playerID
{
    NSLog(@"playerid----->>>%@",playerID);
    self.playerId = playerID;
}

- (void)httpRequest
{
    self.playerId = [self getDataFilePath];
    NSString *url = nil;
    if (self.playerId) {
        url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=%@", self.playerId];
    } else{
        url = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=F642A7DB-0FC4-43D3-9C47-641A458BCA12";
    }
    //NSString *urla = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=F642A7DB-0FC4-43D3-9C47-641A458BCA12";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (self.dataDic) {
            [self.introArr removeAllObjects];
            [self.detailArr removeAllObjects];
        }
        
        self.introArr = [NSMutableArray array];
        NSDictionary *dic = responseObject[@"KCXX"];
        introduceModel *introduce = [[introduceModel alloc] init];
        introduce.className = [dic objectForKey:@"KCMC"];
        introduce.classNickName = [dic objectForKey:@"KCZMC"];
        introduce.imageUrl = [dic objectForKey:@"KCTP"];
        //introduce.introduce = [dic objectForKey:@"KCJS"];
        introduce.author = [dic objectForKey:@"KCDJS"];
        [self.introArr addObject:introduce];
        
        IntroDetail *detail = [[IntroDetail alloc] init];
        detail.detailLb = [dic objectForKey:@"KCJS"];
        [self.detailArr addObject:detail];
        
        NSLog(@"player---%@%@",self.introArr,self.detailArr);
        [self.tableView reloadData];
        [self.dataDic setValue:self.introArr forKey:@"introduce"];
        [self.dataDic setObject:self.detailArr forKey:@"detail"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"PLAYER--%@",error.userInfo);
    }];
}

- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        self.playerId = [path objectAtIndex:0];
        
    }
    
    return self.playerId;
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
