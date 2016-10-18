//
//  GradeController.m
//  美育宝
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "GradeController.h"
#import "FirstTableViewCell.h"
#import "ClassChartModel.h"
#import "ClassChartTableCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "FormValidator.h"
#import "LrdSuperMenu.h"
#import "ChartDetailController.h"
#import "FirstTableViewCellModal.h"
#import "ClassRedModel.h"
#import "GroupChartModel.h"


#define TeacherTableViewFrame CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height - 49-128)
#define StudentTableViewFrame CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 49-88)


@interface GradeController ()<UITableViewDelegate, UITableViewDataSource,LrdSuperMenuDelegate, LrdSuperMenuDataSource>
{
//    NSString *accountType;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *classArr;
@property (nonatomic, strong) NSMutableArray *chartArray;
@property (nonatomic, strong) NSMutableArray *chartIDArray;
@property (nonatomic, strong) NSMutableArray *studyStateArr;
@property (nonatomic, strong) NSMutableArray *stateID;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (nonatomic, strong) LrdSuperMenu *menu;
@end

@implementation GradeController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString* accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
    NSString *stuNj       = [tools sendFileString:@"LoginData.plist" andNumber:8];
    
    
    
        if ([accountType isEqualToString:@"2"]) {
            self.teacherView.hidden = YES;
            [self setUpTableView:StudentTableViewFrame];
            [self getClassCharts:stuNj index:0];
        } else {
            [self getClassCharts:@"1" index:0];
            
            _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
            _menu.delegate = self;
            _menu.dataSource = self;
            [_menu selectDeafultIndexPath];
            [self.view addSubview:_menu];
            [self setUpTableView:TeacherTableViewFrame];
        }
    
    //添加第一名到第三名的点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGoldBtnClick:) name:@"CLASS_GOLDCLICK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSilverBtnClick:) name:@"CLASS_SILVERCLICK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBronzeBtnClick:) name:@"CLASS_BRONZECLICK" object:nil];
   
    
   
}

- (void)setUpTableView:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView = tableView;
        [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassChartTableCell" bundle:nil] forCellReuseIdentifier:@"ClassChartTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RedFlowerViewCell" bundle:nil] forCellReuseIdentifier:@"ClassRedFlowerViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return self.classArr.count-3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"ClassChartTableCell";
//    
////    FirstTableViewCell *cellModel = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    
//    ClassChartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//    
//    if (self.classArr.count > 0) {
//        ClassChartModel *classModel = self.classArr[indexPath.row];
//        cell.chartList = classModel;
//    }
//    
//    
//    return cell;
    static NSString *cellID = nil;
    
    if (indexPath.section == 0) {
        cellID = @"ClassRedFlowerViewCell";
    } else {
        cellID = @"ClassChartTableCell";
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ClassRedModel *redModel = [[ClassRedModel alloc] init];
    
    
    if (self.classArr.count > 0) {
        
        
        if (indexPath.section == 0) {
            if (self.classArr.count > 3) {
                ClassChartModel *groupModel1 = self.classArr.firstObject;
                redModel.firstName = groupModel1.stuName;
                redModel.firstFlowerNum = groupModel1.flowerNumber;
                redModel.firstGroupName = groupModel1.flowerId;
                
                ClassChartModel *groupModel2 = self.classArr[1];
                redModel.secondName          = groupModel2.stuName;
                redModel.secondFlowerNum     = groupModel2.flowerNumber;
                redModel.secondGroupName     = groupModel2.flowerId;
                
                ClassChartModel *groupModel3 = self.classArr[2];
                redModel.thirdName           = groupModel3.stuName;
                redModel.thirdFlowerNum      = groupModel3.flowerNumber;
                redModel.thirdGroupName      = groupModel3.flowerId;
                [cell setTableViewCellModel:redModel];
            }
            
        } else {
            ClassChartModel *groupModel = self.classArr[indexPath.row + 3];
            [cell setTableViewCellModel:groupModel];
        }
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassChartModel *classModel = self.classArr[indexPath.row+3];
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:classModel.flowerId];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",classModel.stuName];
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
- (void)getClassCharts:(NSString *)grade index:(NSInteger)index
{
    
    NSString *chartUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxhhnjph&nj=%@",grade];
    
//    NSLog(@"%@",chartUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chartUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (self.dataDic) {
            [self.classArr removeAllObjects];
        }
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            [self.tableView reloadData];
            return;
        }
        
        self.classArr = [NSMutableArray array];
        for (NSDictionary *parms in responseObject[@"data"]) {
            ClassChartModel *classModel = [ClassChartModel flowerModelWithDictionary:parms];
            
            [self.classArr addObject:classModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.dataDic setValue:self.classArr forKey:@"GRADE"];
//        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
// 暂时关闭这句   [FormValidator showAlertWithStr:@"网络错误"];
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

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

- (NSMutableArray *)classArr
{
    if (!_classArr) {
        _classArr = [[NSMutableArray alloc] init];
    }
    return _classArr;
}

- (NSMutableArray *)chartArray
{
    if (!_chartArray) {
        _chartArray = [[NSMutableArray alloc] init];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        
        [_chartArray addObjectsFromArray:[tools getDataArrayFromPlist:@"StageName.plist"]];
    }
    return _chartArray;
}
- (NSMutableArray *)chartIDArray
{
    if (!_chartIDArray) {
        _chartIDArray = [[NSMutableArray alloc] init];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [_chartIDArray addObjectsFromArray:[tools getDataArrayFromPlist:@"Stage.plist"]];
    }
    return _chartIDArray;
}

- (NSMutableArray *)studyStateArr
{
    if (!_studyStateArr) {
        _studyStateArr = [[NSMutableArray alloc] init];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        
        [_studyStateArr addObjectsFromArray:[tools getDataArrayFromPlist:@"BanJiName.plist"]];
    }
    return _studyStateArr;
}
- (NSMutableArray *)stateID
{
    if (!_stateID) {
        _stateID = [[NSMutableArray alloc] init];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [_stateID addObjectsFromArray:[tools getDataArrayFromPlist:@"BanJiNumber.plist"]];
    }
    return _stateID;
}

#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 2;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.chartArray.count;
    }
    return self.studyStateArr.count;
    
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        return self.chartArray[indexPath.row];
    }
    return self.studyStateArr[indexPath.row];
    //    if (self.chartArray.count > 0) {
    //        return self.chartArray[indexPath.row];
    //    }
    //    return self.studyStateArr[indexPath.row];
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
        
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);

        if (indexPath.column == 0) {
            [self getSmallStageWithIndex:self.chartIDArray[indexPath.row] andIndex:1];
            [self getClassCharts:self.stateID.firstObject index:0];
        } else {
            
            [self getClassCharts:self.stateID[indexPath.row] index:0];
        }
    

        
    }
}

//获取年级 一年级，二年级，三年级。。。。
- (NSArray *)getSmallStageWithIndex:(NSString *)code andIndex:(NSInteger)index
{
    NSString *httpString = nil;
    if (index == 0) {
        httpString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=004001";
    } else {
        httpString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=%@",code];
    }
    
    if (self.studyStateArr) {
        [self.studyStateArr removeAllObjects];
        [self.stateID removeAllObjects];
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *httpUrl = [NSURL URLWithString:httpString];
    NSURLRequest *request = [NSURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        for (NSDictionary *diction in dict[@"data"]) {
            [self.stateID addObject:diction[@"BH"]];
            [self.studyStateArr addObject:diction[@"NJBM"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.menu reloadData];
        });
        
    }];
    [dataTask resume];
    
    
    return self.studyStateArr;
}

//通知点击事件
- (void)setGoldBtnClick:(NSNotification *)goldNotice
{
    
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:goldNotice.userInfo[@"gold"]];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",goldNotice.userInfo[@"goldname"]];
    
    [self.navigationController pushViewController:detail animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GOLDCLICK" object:nil];
}

- (void)setSilverBtnClick:(NSNotification *)silverNotice
{
    NSString *silverid = silverNotice.userInfo[@"silver"];
    NSString *name     = silverNotice.userInfo[@"silvername"];
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:silverid];
    detail.title = [NSString stringWithFormat:@"%@得奖明细",name];
//
    [self.navigationController pushViewController:detail animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SILVERCLICK" object:nil];
}

- (void)setBronzeBtnClick:(NSNotification *)bronzeNotice
{
    ChartDetailController *detail = [[ChartDetailController alloc] initWithCellId:bronzeNotice.userInfo[@"bronze"]];
    detail.title = [NSString stringWithFormat:@"%@得奖明细", bronzeNotice.userInfo[@"bronzename"]];
//
    [self.navigationController pushViewController:detail animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRONZECLICK" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
