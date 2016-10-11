//
//  GroupChartController.m
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "GroupChartController.h"
#import "ChartDetailController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "GroupChartModel.h"
#import "RedFlower.h"
#import "GroupChartTableCell.h"
#import "MYToolsModel.h"
#import "FormValidator.h"
#import "LrdSuperMenu.h"
#import "RedFlowerViewCell.h"
#import "FirstTableViewCellModal.h"


#define TeacherTableViewFrame CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height - 49-128)
#define StudentTableViewFrame CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 49-88)

@interface GroupChartController ()<UITableViewDelegate, UITableViewDataSource,LrdSuperMenuDelegate, LrdSuperMenuDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *stuHeadView;

@property (nonatomic, strong) MYToolsModel *tools;
@property (strong, nonatomic) NSString *accountType;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groupArr;

@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classifyID;
@property (nonatomic, strong) NSMutableDictionary *dicData;

@end

@implementation GroupChartController


- (MYToolsModel *)tools
{
    if (!_tools) {
        _tools = [[MYToolsModel alloc] init];
    }
    return _tools;
}
- (NSMutableArray *)groupArr
{
    if (!_groupArr) {
        _groupArr = [[NSMutableArray alloc] init];
    }
    return _groupArr;
}
- (NSMutableArray *)classify
{
    if (!_classify) {
        _classify = [[NSMutableArray alloc] init];
        [_classify addObjectsFromArray:[self.tools getArrayFromPlistName:@"TeacherClass.plist" andNumber:0]];
    }
    return _classify;
}
- (NSMutableArray *)classifyID
{
    if (!_classifyID) {
        _classifyID = [[NSMutableArray alloc] init];
        [_classifyID addObjectsFromArray:[self.tools getArrayFromPlistName:@"TeacherClass.plist" andNumber:1]];
    }
    return _classifyID;
}
- (NSMutableDictionary *)dicData
{
    if (!_dicData) {
        _dicData = [[NSMutableDictionary alloc] init];
    }
    return _dicData;
}



- (void)viewWillAppear:(BOOL)animated
{
//   [self.classify addObjectsFromArray:[self classifyData]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    self.accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
    
    if ([self.accountType isEqualToString:@"2"]) {
        
        [self setGroupTableView:StudentTableViewFrame];
        self.headerView.hidden = YES;
//        self.stuHeadView.hidden = NO;
        [self getGroupChartHttpRequest:0 classid:[tools sendFileString:@"LoginData.plist" andNumber:4]];
    } else {
//        self.stuHeadView.hidden = YES;
        _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
        _menu.delegate = self;
        _menu.dataSource = self;
        [self.view addSubview:_menu];
        [_menu selectDeafultIndexPath];
        
        [self setGroupTableView:TeacherTableViewFrame];
        
        [self getGroupChartHttpRequest:0 classid:self.classifyID.firstObject];
    }
   
    
   
    
//添加第一名到第三名的点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGoldBtnClick:) name:@"GOLDCLICK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSilverBtnClick:) name:@"SILVERCLICK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBronzeBtnClick:) name:@"BRONZECLICK" object:nil];
    
}


- (void)setGroupTableView:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupChartTableCell" bundle:nil] forCellReuseIdentifier:@"GroupChartTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RedFlowerViewCell" bundle:nil] forCellReuseIdentifier:@"RedFlowerViewCell"];
    
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.groupArr.count-3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = nil;
    
    if (indexPath.section == 0) {
        cellID = @"RedFlowerViewCell";
    } else {
        cellID = @"GroupChartTableCell";
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    RedFlower *redModel = [[RedFlower alloc] init];
 
    
    if (self.groupArr.count > 0) {
      
    
    if (indexPath.section == 0) {
        if (self.groupArr.count > 3) {
            GroupChartModel *groupModel1 = self.groupArr.firstObject;
            redModel.firstName = groupModel1.name;
            redModel.firstFlowerNum = groupModel1.flowerNum;
            redModel.firstGroupName = groupModel1.groupName;
            
            GroupChartModel *groupModel2 = self.groupArr[1];
            redModel.secondName          = groupModel2.name;
            redModel.secondFlowerNum     = groupModel2.flowerNum;
            redModel.secondGroupName     = groupModel2.groupName;
            
            GroupChartModel *groupModel3 = self.groupArr[2];
            redModel.thirdName           = groupModel3.name;
            redModel.thirdFlowerNum      = groupModel3.flowerNum;
            redModel.thirdGroupName      = groupModel3.groupName;
            [cell setTableViewCellModel:redModel];
        }
        
    } else {
        GroupChartModel *groupModel = self.groupArr[indexPath.row + 3];
        [cell setTableViewCellModel:groupModel];
    }
    }
   
    return cell;
     
    
    /*
    static NSString *redCellID = @"RedFlowerViewCell";
    
    static NSString *chartCellID = @"GroupChartTableCell";
    
    
    
        if (indexPath.section == 0) {
            RedFlower *redModel = [[RedFlower alloc] init];
            if (self.groupArr.count > 3) {
                GroupChartModel *groupModel1 = self.groupArr.firstObject;
                redModel.firstName = groupModel1.name;
                redModel.firstFlowerNum = groupModel1.flowerNum;
                redModel.firstGroupName = groupModel1.groupName;
                
                GroupChartModel *groupModel2 = self.groupArr[1];
                redModel.secondName          = groupModel2.name;
                redModel.secondFlowerNum     = groupModel2.flowerNum;
                redModel.secondGroupName     = groupModel2.groupName;
                
                GroupChartModel *groupModel3 = self.groupArr[2];
                redModel.thirdName           = groupModel3.name;
                redModel.thirdFlowerNum      = groupModel3.flowerNum;
                redModel.thirdGroupName      = groupModel3.groupName;
                
                RedFlowerViewCell *redCell = [tableView dequeueReusableCellWithIdentifier:redCellID];
                redCell = [[RedFlowerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:redCellID];
                [redCell setTableViewCellModel:redModel];
                return redCell;
            }
    
//            [redCell setTableViewCellModel:groupModel];
            
        }
            if (self.groupArr.count > 0) {
                GroupChartModel *groupModel = self.groupArr[indexPath.row+3];
                
                GroupChartTableCell *chartCell = [tableView dequeueReusableCellWithIdentifier:chartCellID];
                chartCell = [[GroupChartTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartCellID];
                [chartCell setTableViewCellModel:groupModel];
                return chartCell;
            }
*/
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupChartModel *groupModel = self.groupArr[indexPath.row + 3];
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:groupModel.groupName];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",groupModel.name];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 130.0f;
    } else {
        return UITableViewAutomaticDimension;
    }
}


#pragma mark - HTTPREQUEST
- (void)getGroupChartHttpRequest:(NSInteger)index classid:(NSString *)classid
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *chartUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxhhbjph&bjh=%@",classid];;
        
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:chartUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (self.dicData) {
            [self.groupArr removeAllObjects];
        }
        
        
        
        if ([responseObject[@"XHHJL"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        
        
        
        for (NSDictionary *parmas in responseObject[@"XHHJL"]) {
            GroupChartModel *groupModel = [[GroupChartModel alloc] init];
            groupModel.groupName = parmas[@"XH"];
            groupModel.name    = parmas[@"XM"];
            groupModel.rank    = parmas[@"PM"];
            
            if ([parmas[@"HHZS"] isKindOfClass:[NSNull class]]) {
                groupModel.flowerNum = @"0";
            } else {
                groupModel.flowerNum = [parmas[@"HHZS"] stringValue];
            }
            
            [self.groupArr addObject:groupModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.dicData setValue:self.groupArr forKey:@"GROUP"];
//        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    });
}


//- (NSMutableArray *)classifyData
//{
//    MYToolsModel *tools = [[MYToolsModel alloc] init];
//    NSString *loginCode = [tools sendFileString:@"LoginData.plist" andNumber:0];
//    
//    NSString *logincodeUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyclass&logincode=%@",loginCode];
//    
//    
//    
//    NSURL *httpUrl = [NSURL URLWithString:logincodeUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//    
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
//        [FormValidator showAlertWithStr:@"暂无班级数据"];
//        return nil;
//    }
//    
//    [self.classifyID removeAllObjects];
//    for (NSDictionary *diction in dict[@"data"]) {
//        [self.classifyID addObject:diction[@"BJH"]];
//        [self.classify addObject:diction[@"BJMC"]];
//        
//    }
//    [self getGroupChartHttpRequest:0 classid:self.classifyID.firstObject];
//    
//    
//    
//    
//    
//    
//    /*
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:logincodeUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
//            [FormValidator showAlertWithStr:@"暂无数据"];
//            return;
//        }
//        
//        for (NSDictionary *params in dict[@"data"]) {
//            
//            if ([params[@"BJMC"] isKindOfClass:[NSNull class]]) {
//                [self.classify addObject:@" "];
//            } else {
//                [self.classify addObject:params[@"BJMC"]];
//            }
//            
//            
//            [self.classifyID addObject:params[@"BJH"]];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [self.menu reloadData];
//        });
//        [self getGroupChartHttpRequest:0 classid:self.classifyID.firstObject];
//    }];
//    [dataTask resume];
//    */
//    
//    return self.classify;
//}

#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 1;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
   
        return self.classify.count;
    
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (self.classify.count > 0) {
        return self.classify[indexPath.row];
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
    //    if (indexPath.column < 2) {
    //        return [@(arc4random()%1000) stringValue];
    //    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
   
    return nil;
}

- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        
       NSLog(@"点击了%ld 项目",indexPath.row);
        if (indexPath.row == 0) {
            
        } else {
             [self getGroupChartHttpRequest:1 classid:self.classifyID[indexPath.row]];
        }
       
    }
}


//通知点击事件
- (void)setGoldBtnClick:(NSNotification *)goldNotice
{
    
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:goldNotice.userInfo[@"gold"]];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",goldNotice.userInfo[@"goldname"]];
    
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GOLDCLICK" object:nil];
    
}

- (void)setSilverBtnClick:(NSNotification *)silverNotice
{
    NSString *silverid = silverNotice.userInfo[@"silver"];
    NSString *name     = silverNotice.userInfo[@"silvername"];
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:silverid];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",name];
    
    
    
    [self.navigationController pushViewController:detail animated:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SILVERCLICK" object:nil];
}

- (void)setBronzeBtnClick:(NSNotification *)bronzeNotice
{
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:bronzeNotice.userInfo[@"bronze"]];
    detail.title = [NSString stringWithFormat:@"%@得奖明细", bronzeNotice.userInfo[@"bronzename"]];
    
    [self.navigationController pushViewController:detail animated:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRONZECLICK" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
