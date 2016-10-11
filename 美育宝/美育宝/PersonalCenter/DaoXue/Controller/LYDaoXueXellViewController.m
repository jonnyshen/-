//
//  LYDaoXueXellViewController.m
//  Page Demo
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYDaoXueXellViewController.h"
#import "LYRightBarBtn.h"
#import "LYAddViewController.h"
#import "LBXellTableViewCell.h"
#import "FormValidator.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "LrdSuperMenu.h"
#import "MYToolsModel.h"
#import "DXMessageController.h"

#import "LBCellModel.h"
#import "onlyBTModel.h"
#import "FirstTableViewCellModal.h"

#define kDAOXUELBTEACHERURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=131&ucode=R000000003&usertype=1"
#define kDAOXUELBSTUDENTURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=131&ucode=R000000003&usertype=2"

@interface LYDaoXueXellViewController ()<UITableViewDelegate, UITableViewDataSource,LrdSuperMenuDelegate, LrdSuperMenuDataSource>
{
    NSString *classifyList;
    NSString *sortList;
    NSString *chooesList;
    
    NSString *_userCode;
    NSString *_pwd;
    NSString *_userName;
    NSString *_accountType;
    
    NSString *periodName;
    NSString *class_Number;
    NSString *materail;
    NSString *periodID;
}
@property (nonatomic, strong) LYRightBarBtn *right;
@property (nonatomic, strong) NSMutableArray *arrayBT;
@property (nonatomic, strong) NSMutableArray *arrayTextView;
@property (nonatomic, strong) NSMutableDictionary *mutaDic;
@property (nonatomic, strong) NSArray *order;
@property (assign, nonatomic) BOOL post;

@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSMutableArray *choose;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classes;

@property (nonatomic, strong) NSMutableArray *classArr;
@property (nonatomic, strong) NSMutableArray *materialCodeArr;
@property (nonatomic, strong) NSMutableArray *materialNameArr;
@property (nonatomic, strong) NSMutableArray *unitsCodeArr;
@property (nonatomic, strong) NSMutableArray *unitsNameArr;
@property (nonatomic, strong) NSMutableArray *unitsIDArr;
@property (nonatomic, strong) NSMutableArray *periodNameArr;
@property (nonatomic, strong) NSMutableArray *periodIDArr;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation LYDaoXueXellViewController

- (NSMutableArray *)classify
{
    if (!_classify) {
        _classify = [NSMutableArray arrayWithObject:@"全部班级"];
        [_classify addObjectsFromArray:[self getClassRequest]];
    }
    return _classify;
}

- (NSMutableArray *)classArr
{
    if (!_classArr) {
        _classArr = [[NSMutableArray alloc] init];
    }
    return _classArr;
}
// --------------------------
- (NSMutableArray *)sort
{
    if (!_sort) {
        _sort = [NSMutableArray arrayWithObject:@"教材"];
        [_sort addObjectsFromArray:[self getMaterialWithHttpRequest:nil toIndex:0]];
    }
    return _sort;
}

- (NSMutableArray *)materialNameArr
{
    if (!_materialNameArr) {
        _materialNameArr = [[NSMutableArray alloc] init];
    }
    return _materialNameArr;
}
// -----------------------
- (NSMutableArray *)choose
{
    if (!_choose) {
        _choose = [NSMutableArray arrayWithObject:@"单元"];
        [_choose addObjectsFromArray:[self getUnitsWithHTTPRequest:nil toIndex:0]];
    }
    return _choose;
}

- (NSMutableArray *)materialCodeArr
{
    if (!_materialCodeArr) {
        _materialCodeArr = [[NSMutableArray alloc] init];
    }
    return _materialCodeArr;
}

//  ----------------
- (NSMutableArray *)classes
{
    if (!_classes) {
        _classes = [NSMutableArray array];
        [_classes addObjectsFromArray:[self getPeriodFromUnitsWithHttpRequest:nil toIndex:0]];
    }
    return _classes;
}

- (NSMutableArray *)unitsIDArr
{
    if (!_unitsIDArr) {
        _unitsIDArr = [[NSMutableArray alloc] init];
    }
    return _unitsIDArr;
}

- (NSMutableArray *)periodIDArr
{
    if (!_periodIDArr) {
        _periodIDArr = [[NSMutableArray alloc] init];
    }
    return _periodIDArr;
}

- (NSMutableArray *)arrayBT
{
    if (!_arrayBT) {
        _arrayBT = [NSMutableArray array];
    }
    return _arrayBT;
}
- (NSMutableArray *)arrayTextView
{
    if (!_arrayTextView) {
        _arrayTextView = [NSMutableArray array];
    }
    return _arrayTextView;
}
- (NSMutableDictionary *)mutaDic
{
    if (!_mutaDic) {
        _mutaDic = [NSMutableDictionary dictionary];
    }
    return _mutaDic;
}

- (LYRightBarBtn *)right
{
    if (!_right) {
        _right = [[LYRightBarBtn alloc]init];
    }
    return _right;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"导学列表";
    
    [self setUpTableView];
    
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
    
//    [self httpRequest:nil teachingMaterial:nil unit:nil period:nil atIndex:0];
    
    [self.tableView headerBeginRefreshing];
    
    periodName   = self.classes[0];
//    class_Number = self.classArr[1];
//    materail     = self.materialCodeArr[0];
//    periodID     = self.periodIDArr[1];
    
//    NSNotification *notifcation = [NSNotification notificationWithName:@"CLASS_NUMBER_ID" object:nil userInfo:@{@"classNumberID":self.classArr.firstObject}];
//    [[NSNotificationCenter defaultCenter] postNotification:notifcation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataBase:) name:@"TEACHING_MATERIAL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUnitData:) name:@"UNIT_RELOAD" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendClassName) name:@"ADD_DAOXUE_BTNCLICK" object:nil];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.tableView = table;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBXellTableViewCell" bundle:nil] forCellReuseIdentifier:@"Xell"];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToPersonalCenter:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoAddVC:(id)sender {
    
    LYAddViewController *addVC = [[LYAddViewController alloc]initWithTargetPeriodName:periodName withSender:class_Number materialCode:materail periodID:periodID];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addVC];
    nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LYAddView"];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)addClass:(id)sender
{
     LYAddViewController *addVC = [[LYAddViewController alloc]initWithTargetPeriodName:periodName withSender:class_Number materialCode:materail periodID:periodID];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:addVC];
    nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LYAddView"];
    
    
    [self presentViewController:nav animated:YES completion:nil];
}



#pragma  mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayBT.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Xell";
    LBXellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell.orderBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1] forState:UIControlStateNormal];
    if (self.arrayBT.count > 0) {
        LBCellModel * model = self.arrayBT[indexPath.row];
        [cell setLBTableViewCellModel:model];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LBCellModel * model = self.arrayBT[indexPath.row];
    
    DXMessageController *message = [[DXMessageController alloc] initWithDXID:model.dxid];
    message.title = model.titleBT;
    [self.navigationController pushViewController:message animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrayBT removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    LBCellModel *cellModel = self.arrayBT[indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=deldx&dxid=%@",cellModel.dxid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
//            [FormValidator showAlertWithStr:@"删除成功"];
        } else {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 4;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.classify.count;
    }else if(column == 1) {
        return self.sort.count;
    } else if (column == 2){
        return self.choose.count;
    } else {
        return self.classes.count;
    }
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.classify[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.sort[indexPath.row];
    } else if (indexPath.column == 2) {
        return self.choose[indexPath.row];
    }else {
        return self.classes[indexPath.row];
    }
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
    if (column == 0) {
        if (row == 3) {
            //return self.jiachang.count;
        }else if (row == 4) {
            //return self.difang.count;
        }else if (row == 5) {
            //return self.tese.count;
        }else if (row == 6) {
            //return self.rihan.count;
        }else if (row == 7) {
            //return self.xishi.count;
        }else if (row == 8) {
            //return self.shaokao.count;
        }
    }
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        if (row == 3) {
            //return self.jiachang[indexPath.item];
        }else if (row == 4) {
            //return self.tese[indexPath.item];
        }else if (row == 5) {
            //return self.rihan[indexPath.item];
        }else if (row == 6) {
            //return self.xishi[indexPath.item];
        }else if (row == 7) {
            //return self.shaokao[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        NSLog(@"2222");
        if (indexPath.column == 0 && indexPath.row > 0) {
            //教材更新数据
            classifyList = self.classArr[indexPath.row - 1];
            class_Number = classifyList;
            [self.sort removeAllObjects];
            [self.sort addObject:@"教材"];
            [self.sort addObjectsFromArray:[self getMaterialWithHttpRequest:classifyList toIndex:1]];
            
            NSNotification *notifcation = [NSNotification notificationWithName:@"CLASS_NUMBER_ID" object:nil userInfo:@{@"classNumberID":classifyList}];
            [[NSNotificationCenter defaultCenter] postNotification:notifcation];
           
            
        } else if (indexPath.column == 1 && indexPath.row > 0) {
            //点击了教材，单元开始更新数据
            sortList = self.materialNameArr[indexPath.row - 1];
            [self.choose removeAllObjects];
            [self.choose addObject:@"单元"];
            [self.choose addObjectsFromArray:[self getUnitsWithHTTPRequest:sortList toIndex:1]];
            
        } else if (indexPath.column == 2 && indexPath.row > 0) {
//            点击了单元，课时开始更新数据
            chooesList = self.materialCodeArr[indexPath.row - 1];
            materail = chooesList;
            [self.classes removeAllObjects];
            [self.classes addObject:@"课时"];
            [self.classes addObjectsFromArray:[self getPeriodFromUnitsWithHttpRequest:chooesList toIndex:1]];
            
            
        } else if (indexPath.column == 3 && indexPath.row > 0) {
            
            
            periodID   = self.periodIDArr[indexPath.row - 1];
            [self httpRequest:nil teachingMaterial:chooesList unit:nil period:periodID atIndex:1];
            periodName = self.classes[indexPath.row];
//            MYToolsModel *tools = [[MYToolsModel alloc] init];
//            [tools saveToPlistWithPlistName:@"Fuck.plist" andData:self.classes[indexPath.row]];
        }
    }
}

//获取班级名称和班级号
- (NSArray *)getClassRequest
{
    [self getDataFilePath];
//    NSLog(@"%@",_userName);
    NSString *getClassURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyclass&logincode=%@",_userName];
    
    NSMutableArray *classArr = [NSMutableArray array];
    NSString *codeString = [getClassURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlString = [NSURL URLWithString:codeString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    for (NSDictionary *params in dict[@"data"]) {
        
        if ([params[@"BJMC"] isKindOfClass:[NSNull class]]) {
            [classArr addObject:@" "];
        } else {
            [classArr addObject:params[@"BJMC"]];
        }
        
        
        [self.classArr addObject:params[@"BJH"]];
    }
    return classArr;
}

//获取教材名称
- (NSArray *)getMaterialWithHttpRequest:(NSString *)classNumber toIndex:(NSInteger)index
{
    [self getDataFilePath];
        NSMutableArray *materArr = [NSMutableArray array];
    NSString *materialUrl = nil;
    if (index == 0) {
        
        if (!self.classArr) {
            materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=%@&bjh=gz01020101",_userName];
        } else {
            materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=%@&bjh=%@",_userName, self.classArr.firstObject];
        }
        
    } else {
        materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=%@&bjh=%@",_userName, classNumber];
    }
    
//    NSLog(@"---%@",materialUrl);
    
    NSString *codeString = [materialUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlString = [NSURL URLWithString:codeString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    for (NSDictionary *params in dict[@"data"]) {
        [materArr addObject:params[@"JCMC"]];
        [self.materialNameArr addObject:params[@"JCDM"]];
    }
    
     NSNotification *notic = [NSNotification notificationWithName:@"TEACHING_MATERIAL" object:nil userInfo:@{@"materialNameArr":self.materialNameArr.firstObject}];
    [[NSNotificationCenter defaultCenter] postNotification:notic];
    
    return materArr;
}

//获取教材单元目录
- (NSArray *)getUnitsWithHTTPRequest:(NSString *)bookCode toIndex:(NSInteger)index
{
    
    NSMutableArray *unitsArr = [NSMutableArray array];
    NSString *unitsUrl = nil;
    if (index == 0) {
        
        if (!self.materialNameArr) {
            unitsUrl = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=978107150356";
        } else {
            unitsUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=%@",self.materialNameArr.firstObject];
        }
        
    } else {
        unitsUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=%@",bookCode];
    }
    
    
    NSString *codeString = [unitsUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlString = [NSURL URLWithString:codeString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    for (NSDictionary *params in dict[@"data"]) {
        [unitsArr addObject:params[@"BT"]];
        [self.materialCodeArr addObject:params[@"ZBH"]];
    }
    
    NSNotification *notic = [NSNotification notificationWithName:@"UNIT_RELOAD" object:nil userInfo:@{@"materialCodeArr":self.materialNameArr.firstObject}];
    [[NSNotificationCenter defaultCenter] postNotification:notic];
    
    return unitsArr;
    
    
}

//获取单元下的课时
- (NSArray *)getPeriodFromUnitsWithHttpRequest:(NSString *)period toIndex:(NSInteger)index
{
        NSMutableArray *periodArr = [NSMutableArray array];
    NSString *periodURL = nil;
    if (index == 0) {
        if (!self.materialCodeArr) {
            periodURL = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=130";
        } else {
            periodURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",self.materialCodeArr.firstObject];
        }
        
    } else {
        periodURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",period];
    }
//    NSLog(@"%@",periodURL);
    NSString *codeURL = [periodURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:codeURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error          = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dictionary[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    [self.periodIDArr removeAllObjects];
    for (NSDictionary *params in dictionary[@"data"]) {
        [periodArr addObject:params[@"BT"]];

        [self.periodIDArr addObject:params[@"ZBH"]];
    }
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveDataToPlistWithPlistName:@"ZBHid.plist" andData:self.periodIDArr];

     [self httpRequest:nil teachingMaterial:nil unit:nil period:self.periodIDArr.firstObject atIndex:0];
    
    return periodArr;
    
}


#pragma mark - AFHttp
- (void)httpRequest:(NSString *)class teachingMaterial:(NSString *)material unit:(NSString *)unitid period:(NSString *)periods atIndex:(NSInteger)index
{
    [self getDataFilePath];
    

    NSString *daoXueUrl = nil;
    
    if (index == 0) {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%@&ucode=%@&usertype=%@",periods, _userCode,_accountType];
    } else {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%@&ucode=%@&usertype=%@", material ,_userCode, _accountType];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:daoXueUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"AAAAAAAA==%@",responseObject);
        if (self.mutaDic) {
            [self.arrayBT removeAllObjects];
            [self.arrayTextView removeAllObjects];
        }
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
             [FormValidator showAlertWithStr:@"暂无数据"];
            [self.tableView reloadData];
            return;
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            LBCellModel * model = [[LBCellModel alloc] init];
            model.dxid    = dic[@"DXID"];
            model.titleBT = dic[@"DXBT"];
            model.times = dic[@"CJSJ"];
            model.message = dic[@"DXMS"];
            model.isPost = [dic[@"DXZT"] stringValue];
            [self.arrayBT addObject:model];
        }
//        NSLog(@"array--%@",self.arrayBT);
        [self.mutaDic setValue:self.arrayBT forKey:@"arrayBT"];
        
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"获取数据失败"];
    }];
    
    
    
    
}


//获取用户登录信息
- (void)getDataFilePath
{
    NSString *fileName = @"LoginData.plist";
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    _userCode    =  [tools sendFileString:fileName andNumber:2];
    _pwd =  [tools sendFileString:fileName andNumber:1];
    _userName    =  [tools sendFileString:fileName andNumber:0];
    
    _accountType = [tools sendFileString:fileName andNumber:5];
}

#pragma mark - 通知实行方法

- (void)reloadDataBase:(NSNotification *)notic
{
    //            单元更新数据
    [self.choose removeAllObjects];
    [self.choose addObject:@"单元"];
    [self.choose addObjectsFromArray:[self getUnitsWithHTTPRequest:notic.userInfo[@"materialNameArr"] toIndex:0]];
}

- (void)reloadUnitData:(NSNotification *)notice
{
    //课时更新数据
    [self.classes removeAllObjects];
    [self.classes addObject:@"课时"];
    [self.classes addObjectsFromArray:[self getPeriodFromUnitsWithHttpRequest:notice.userInfo[@"materialCodeArr"] toIndex:0]];
   
}

- (void)sendClassName
{
    if (periodName ) {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"Fuck.plist" andData:periodName];
        
    }
    
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    LYAddViewController *addVC = segue.destinationViewController;
//    addVC.delegate =self;
//}


@end
