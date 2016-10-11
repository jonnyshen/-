//
//  StuDXListController.m
//  美育宝
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "StuDXListController.h"
#import "LrdSuperMenu.h"
#import "FormValidator.h"
#import "MYToolsModel.h"
#import "AFNetworking.h"
#import "LBCellModel.h"
#import "LBXellTableViewCell.h"
#import "DXMessageController.h"

@interface StuDXListController ()<LrdSuperMenuDelegate,LrdSuperMenuDataSource,NSURLSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *_userName;
    NSString *_classNumber;
    NSString *_accountType;
    NSString *_userCode;
}
@property (nonatomic, strong) LrdSuperMenu *menu;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *modalArr;
@property (nonatomic , strong) NSMutableDictionary *modalDic;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSMutableArray *choose;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classID;
@property (nonatomic, strong) NSMutableArray *chooseIdenity;
@property (nonatomic, strong) NSMutableArray *sortBH;
@property (nonatomic, strong) NSMutableArray *subjectCode;
@end

@implementation StuDXListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        _userName = [tools sendFileString:@"LoginData.plist" andNumber:0];
        _classNumber = [tools sendFileString:@"LoginData.plist" andNumber:4];
        _accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self getChoosebufferinRange:self.sortBH.firstObject];
    
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
    
    [self httpRequest:@"" atIndex:0];
    
    [self setUpTableView];
}

- (void)setUpTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-49-40)];
    
    self.tableView = table;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBXellTableViewCell" bundle:nil] forCellReuseIdentifier:@"Xell"];
}

#pragma mark - AFHttp
- (void)httpRequest:(NSString *)classid atIndex:(NSInteger)index
{
    
    
    NSString *daoXueUrl = nil;
    
    if (index == 0) {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%@&ucode=%@&usertype=%@",classid, _userCode,_accountType];
    } else {
        daoXueUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getksdxml&zbh=%@&ucode=%@&usertype=%@", classid ,_userCode, _accountType];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:daoXueUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //        NSLog(@"AAAAAAAA==%@",responseObject);
        if (self.modalDic) {
            [self.dataArr removeAllObjects];
        
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
            [self.dataArr addObject:model];
        }
        //        NSLog(@"array--%@",self.arrayBT);
        [self.modalDic setValue:self.dataArr forKey:@"dataArr"];
        
        [self.tableView reloadData];

        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"获取数据失败"];
    }];
    
}

#pragma  mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Xell";
    LBXellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [cell.orderBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1] forState:UIControlStateNormal];
    if (self.dataArr.count > 0) {
        LBCellModel * model = self.dataArr[indexPath.row];
        [cell setLBTableViewCellModel:model];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LBCellModel * model = self.dataArr[indexPath.row];
    
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
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    LBCellModel *cellModel = self.dataArr[indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=deldx&dxid=%@",cellModel.dxid] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            //            [FormValidator showAlertWithStr:@"删除成功"];
        } else {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}







#pragma mark - 获取筛选框数据
//获取教材
- (NSArray *)getClassifybuffer:(NSInteger)index
{
    NSMutableArray *materArr = [NSMutableArray array];
    
      NSString* materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjkc&logincode=&bjh=%@", _classNumber];
    

    /*
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:materialUrl]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        
        [self.classID removeAllObjects];
        for (NSDictionary *params in dict[@"data"]) {
            [materArr addObject:params[@"JCMC"]];
            [self.classID addObject:params[@"JCDM"]];
        }

    }];
    [dataTask resume];
    return materArr;
     */
//    NSLog(@"马特人%@",materialUrl);
    NSURL *urlString = [NSURL URLWithString:materialUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    [self.classID removeAllObjects];
    for (NSDictionary *params in dict[@"data"]) {
        [materArr addObject:params[@"JCMC"]];
        [self.classID addObject:params[@"JCDM"]];
    }

    return materArr;
}

//获取单元
- (NSArray *)getSortbuffer:(NSString *)inRange
{
    NSMutableArray *sortArr = [NSMutableArray array];
    
    NSString* materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=%@",inRange];
    
    
    /*
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:materialUrl]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        [self.sortBH removeAllObjects];
        for (NSDictionary *params in dict[@"data"]) {
            [sortArr addObject:params[@"BT"]];
            [self.sortBH addObject:params[@"ZBH"]];
        }
        
    }];
    [dataTask resume];
    return sortArr;
     */
    NSURL *urlString = [NSURL URLWithString:materialUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    [self.sortBH removeAllObjects];
    for (NSDictionary *params in dict[@"data"]) {
        [sortArr addObject:params[@"BT"]];
        [self.sortBH addObject:params[@"ZBH"]];
    }

    return sortArr;
}

//获取课时
- (NSArray *)getChoosebufferinRange:(NSString *)range
{
    NSMutableArray *chooseArr = [NSMutableArray array];
    
    NSString* materialUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",range];
    
    
    /*
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:materialUrl]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        [self.chooseIdenity removeAllObjects];
        for (NSDictionary *params in dict[@"data"]) {
            [chooseArr addObject:params[@"BT"]];
            
            [self.chooseIdenity addObject:params[@"ZBH"]];
        }

        
    }];
    [dataTask resume];
    return chooseArr;
     */
    NSURL *urlString = [NSURL URLWithString:materialUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    
    [self.chooseIdenity removeAllObjects];
    for (NSDictionary *params in dict[@"data"]) {
        [chooseArr addObject:params[@"BT"]];
        
        [self.chooseIdenity addObject:params[@"ZBH"]];
    }

    return chooseArr;
}


#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 3;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
//    if (self.classify.count > 0) {
        if (column == 0) {
            return self.classify.count;
        }else if(column == 1) {
            return self.sort.count;
        } else {
            return self.choose.count;
        }
//    }
    
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
//        if (self.classify.count > 0) {
            return self.classify[indexPath.row];
//        }
        
    }else if(indexPath.column == 1) {
//        if (self.sort.count > 0) {
            return self.sort[indexPath.row];
//        }
        
    } else  {
//        if (self.choose.count > 0) {
            return self.choose[indexPath.row];
//        }
        
    }
    return nil;
}





- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        
        if (indexPath.column == 0 && indexPath.row > 0) {
            
           
            [self.sort removeAllObjects];
            [self.sortBH removeAllObjects];
            [self.sort addObjectsFromArray:[self getSortbuffer:self.classID[indexPath.row-1]]];
            
        } else if (indexPath.column == 1 && indexPath.row > 0) {
            
            
        } else if (indexPath.column == 2 && indexPath.row > 0){
           
        }
    }
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
        _classify = [[NSMutableArray alloc] init];
        [_classify addObjectsFromArray:[self getClassifybuffer:0]];
    }
    return _classify;
}
- (NSMutableArray *)classID
{
    if (!_classID) {
        _classID = [[NSMutableArray alloc] init];
        
    }
    return _classID;
}

- (NSMutableArray *)sort
{
    if (!_sort) {
        _sort = [[NSMutableArray alloc] init];
        [_sort addObjectsFromArray:[self getSortbuffer:self.classID.firstObject]];
    }
    return _sort;
}
-(NSMutableArray *)sortBH
{
    if (!_sortBH) {
        _sortBH = [[NSMutableArray alloc] init];
    }
    return _sortBH;
}

- (NSMutableArray *)choose
{
    if (!_choose) {
        _choose = [[NSMutableArray alloc] init];
        [_choose addObjectsFromArray:[self getChoosebufferinRange:self.sortBH.firstObject]];
    }
    return _choose;
}
-(NSMutableArray *)chooseIdenity
{
    if (!_chooseIdenity) {
        _chooseIdenity = [[NSMutableArray alloc] init];
    }
    return _chooseIdenity;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
