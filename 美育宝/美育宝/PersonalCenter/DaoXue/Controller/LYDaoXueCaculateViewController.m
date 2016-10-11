//
//  LYDaoXueCaculateViewController.m
//  Page Demo
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYDaoXueCaculateViewController.h"
#import "LrdSuperMenu.h"
#import "MYToolsModel.h"
#import "AFNetworking.h"
#import "FormValidator.h"
#import "LBCellModel.h"
#import "CaculateCell.h"
#import "HomeWorkStateController.h"

@interface LYDaoXueCaculateViewController ()<UITableViewDelegate, UITableViewDataSource, LrdSuperMenuDelegate, LrdSuperMenuDataSource>
{
    NSString *classifyList;
    NSString *sortList;
    NSString *chooesList;
    
    NSString *_userCode;
    NSString *_pwd;
    NSString *_userName;
    NSString *_accountType;
    NSString *_classNumber;
}

@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSMutableArray *choose;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) NSMutableArray *classArr;
@property (nonatomic, strong) NSMutableArray *materialCodeArr;
@property (nonatomic, strong) NSMutableArray *materialNameArr;
@property (nonatomic, strong) NSMutableArray *unitsIDArr;
@property (nonatomic, strong) NSMutableArray *caculateArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LYDaoXueCaculateViewController

- (NSMutableArray *)caculateArray
{
    if (!_caculateArray) {
        _caculateArray = [[NSMutableArray alloc] init];
    }
    return _caculateArray;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    self.title = @"导学统计";
    
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
    
    [self httpRequest:nil teachingMaterial:nil unit:nil period:nil atIndex:0];
    
    _classNumber = self.classArr.firstObject;
    
    [self setUpTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassNumberID:) name:@"CLASS_NUMBER_ID" object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getClassNumberID:(NSNotification *)notic
{
    _classNumber = notic.userInfo[@"classNumberID"];
}

- (void)setUpTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+64, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
            [self.view addSubview:_tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"CaculateCell" bundle:nil] forCellReuseIdentifier:@"CaculateCell"];
}

#pragma mark - AFHttp
- (void)httpRequest:(NSString *)class teachingMaterial:(NSString *)material unit:(NSString *)unitid period:(NSString *)periods atIndex:(NSInteger)index
{
    [self getDataFilePath];
    
    
    NSString *daoXueUrl = nil;
    
    if (index == 0) {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%d&ucode=%@&usertype=%@",131, _userCode,_accountType];
    } else {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%@&ucode=%@&usertype=%@", material ,_userCode, _accountType];
    }
    
    //
    LBCellModel * model = [[LBCellModel alloc] init];
    NSMutableArray *dxidArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:daoXueUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"AAAAAAAA==%@",responseObject);
        
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            if ([[dic[@"DXZT"] stringValue] isEqualToString:@"1"]) {
                model.dxid    = dic[@"DXID"];
                model.titleBT = dic[@"DXBT"];
                model.times = dic[@"CJSJ"];
                model.message = dic[@"DXMS"];
                [self.caculateArray addObject:model];
                
                [dxidArray addObject:dic[@"DXID"]];
            }
            
        }
       
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"获取数据失败"];
    }];
    
    
    for (int i = 0; i < self.caculateArray.count; i++) {
        NSString *dxidURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getdxwctj&dxid=%@&bh=%@",dxidArray[i],_classNumber];
        [manager GET:dxidURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
                    [FormValidator showAlertWithStr:@"暂无数据"];
                    [self.tableView reloadData];
                    return;
                
            }
            for (NSDictionary *params in responseObject[@"data"]) {
                model.studentName = params[@"XM"];
                model.finishType  = params[@"WCZT"];
                model.personImage = params[@"PersonImage"];
                [self.caculateArray addObject:model];
            }
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
    }
    
    [self.tableView reloadData];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.caculateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaculateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaculateCell" forIndexPath:indexPath];
    LBCellModel *cellModel = self.caculateArray[indexPath.row];
    cell.cellModel = cellModel;
    cell.orderLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LBCellModel *cellModel = self.caculateArray[indexPath.row];
    HomeWorkStateController *homeState = [[HomeWorkStateController alloc] initWithDxid:cellModel.dxid andClassNumber:_classNumber];
    homeState.title = cellModel.titleBT;
    [self.navigationController pushViewController:homeState animated:YES];
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
    [self.caculateArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    LBCellModel *cellModel = self.caculateArray[indexPath.row];
    
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
    //if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    //}
    //return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    //if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    //}
    //return nil;
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
            
            classifyList = self.classArr[indexPath.row - 1];
            [self.sort removeAllObjects];
            [self.sort addObject:@"教材"];
            [self.sort addObjectsFromArray:[self getMaterialWithHttpRequest:classifyList toIndex:1]];
            
            
        } else if (indexPath.column == 1 && indexPath.row > 0) {
            
            sortList = self.materialNameArr[indexPath.row - 1];
            [self.choose removeAllObjects];
            [self.choose addObject:@"单元"];
            [self.choose addObjectsFromArray:[self getUnitsWithHTTPRequest:sortList toIndex:1]];
            
            
        } else if (indexPath.column == 2 && indexPath.row > 0) {
            
            chooesList = self.materialCodeArr[indexPath.row - 1];
            [self.classes removeAllObjects];
            [self.classes addObject:@"课时"];
            [self.classes addObjectsFromArray:[self getPeriodFromUnitsWithHttpRequest:chooesList toIndex:1]];
            
        } else if (indexPath.column == 3 && indexPath.row > 0) {
            
            
            
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
        materialUrl = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=cyp&bjh=gz01020101";
    } else {
        materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=%@&bjh=%@",_userName, classNumber];
    }
    
    NSLog(@"---%@",materialUrl);
    
    NSString *codeString = [materialUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *urlString = [NSURL URLWithString:codeString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    for (NSDictionary *params in dict[@"data"]) {
        [materArr addObject:params[@"JCMC"]];
        [self.materialNameArr addObject:params[@"JCDM"]];
    }
    
    
    return materArr;
}

//获取教材单元目录
- (NSArray *)getUnitsWithHTTPRequest:(NSString *)bookCode toIndex:(NSInteger)index
{
    
    
    
    NSMutableArray *unitsArr = [NSMutableArray array];
    NSString *unitsUrl = nil;
    if (index == 0) {
        unitsUrl = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=978107150356";
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
    for (NSDictionary *params in dict[@"data"]) {
        [unitsArr addObject:params[@"BT"]];
        [self.materialCodeArr addObject:params[@"ZBH"]];
    }
    
    
    return unitsArr;
    
    
}

//获取单元下的课时
- (NSArray *)getPeriodFromUnitsWithHttpRequest:(NSString *)period toIndex:(NSInteger)index
{
   
    NSMutableArray *periodArr = [NSMutableArray array];
    NSString *periodURL = nil;
    if (index == 0) {
        periodURL = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=130";
    } else {
        periodURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",period];
    }
    NSString *codeURL = [periodURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:codeURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error          = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    for (NSDictionary *params in dictionary[@"data"]) {
        [periodArr addObject:params[@"BT"]];
        [self.unitsIDArr addObject:params[@"ZBH"]];
    }
//    NSLog(@"%@",self.unitsIDArr);
    
    return periodArr;
    
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
        _classes = [NSMutableArray arrayWithObject:@"课时"];
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

@end
