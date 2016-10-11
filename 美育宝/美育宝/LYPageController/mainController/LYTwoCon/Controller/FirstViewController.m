//
//  FirstViewController.m
//  Page Demo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "FirstViewController.h"
#import "LYPlayerViewController.h"
#import "FirstTableViewCell.h"
#import "FirstTableViewCellModal.h"
#import "TRSchoolClass.h"
#import "Stage.h"

#import "MJRefresh.h"
#import "AFNetworking.h"
#import "FormValidator.h"

#import "LrdSuperMenu.h"
#import "MYToolsModel.h"

#define FirstUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkclist&pagesize=10&pageindex=1&key=&jdid=&kch=&nj="

static NSInteger one = 0;
static NSInteger two = 0;

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource, LrdSuperMenuDelegate, LrdSuperMenuDataSource>

@property (strong, nonatomic) UITableView *tableView;
//@property (nonatomic, strong) TouchHiddenView *headerView;
@property (nonatomic , strong) NSMutableArray *modalArr;
@property (nonatomic , strong) NSMutableDictionary *modalDic;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSMutableArray *choose;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classID;

@property (nonatomic, strong) NSMutableArray *sortBH;
@property (nonatomic, strong) NSMutableArray *subjectCode;
@property (nonatomic, strong) NSMutableArray *subject;
@property (nonatomic, strong) NSArray *rihan;
@property (nonatomic, strong) NSArray *xishi;
@property (nonatomic, strong) NSArray *shaokao;

@property (nonatomic, strong) NSString *nianji;

@end

@implementation FirstViewController

- (NSMutableArray *)classify
{
    if (!_classify) {
        _classify = [NSMutableArray arrayWithObject:@"学习阶段"];
        [_classify addObjectsFromArray:[self getEducationStage]];
    }
    return _classify;
}

- (NSMutableArray *)classID
{
    if (!_classID) {
        _classID = [NSMutableArray array];
    }
    return _classID;
}

- (NSArray *)sort
{
    if (!_sort) {
        _sort = [NSMutableArray arrayWithObject:@"年级"];
        [_sort addObjectsFromArray:[self getSmallStageWithIndex:nil andIndex:0]];
    }
    return _sort;
}

- (NSMutableArray *)sortBH
{
    if (!_sortBH) {
        _sortBH = [[NSMutableArray alloc] init];
    }
    return _sortBH;
}

- (NSMutableArray *)choose
{
    if (!_choose) {
        _choose = [NSMutableArray arrayWithObject:@"科目"];
        [_choose addObjectsFromArray:[self getAllSubject]];
    }
    return _choose;
}

- (NSMutableArray *)subjectCode
{
    if (!_subjectCode) {
        _subjectCode = [NSMutableArray array];
    }
    return _subjectCode;
}

- (NSMutableArray *)modalArr
{
    if (!_modalArr) {
        _modalArr = [[NSMutableArray alloc] init];
    }
    return _modalArr;
}

- (NSMutableDictionary *)modalDic
{
    if (!_modalDic) {
        _modalDic = [NSMutableDictionary dictionary];
    }
    return _modalDic;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    
    
    
    [self setUpTableView];
    [self httpRequestWithStage:@"" andClassCode:@"" andSubject:@"" transferNumber:0];
    
//    [self.tableView headerBeginRefreshing];
    
    
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
    
}



- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 250)];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self.view addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"FirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    
}


#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 3;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.classify.count;
    }else if(column == 1) {
        return self.sort.count;
    } else {
        return self.choose.count;
    }

}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.classify[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.sort[indexPath.row];
    } else  {
        return self.choose[indexPath.row];
    }
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
        return @"baidu";

}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
        return @"baidu";

}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column < 2) {
        return [@(arc4random()%1000) stringValue];
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return [@(arc4random()%1000) stringValue];
}


- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        
        if (indexPath.column == 0 && indexPath.row > 0) {
            
            one = indexPath.row - 1;
            [self.sort removeAllObjects];
            [self.sort addObject:@"年级"];
            [self.sort addObjectsFromArray:[self getSmallStageWithIndex:self.classID[indexPath.row - 1] andIndex:1]];
            [self httpRequestWithStage:self.classID[indexPath.row - 1] andClassCode:@"" andSubject:@"" transferNumber:1];
            
            
        } else if (indexPath.column == 1 && indexPath.row > 0) {
            two = indexPath.row - 1;
            [self httpRequestWithStage:self.classID[one] andClassCode:@"" andSubject:self.sortBH[two] transferNumber:1];
            
        } else if (indexPath.column == 2 && indexPath.row > 0){
            [self httpRequestWithStage:self.classID[one] andClassCode:self.subjectCode[indexPath.row - 1] andSubject:self.sortBH[two] transferNumber:1];
        }
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"firstCell";
    FirstTableViewCellModal *cellModal = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (self.modalArr.count > 0) {
    TRSchoolClass *modal = self.modalArr[indexPath.row];
        [cellModal setTableViewCellModel:modal];
    }
    return cellModal;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TRSchoolClass *school = self.modalArr[indexPath.row];
    NSString *playerID    = school.playerID;
    [self stringFromPlist:school.playerID andOther:@""];
    LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:playerID andComeFromWhichVC:@"FIRST"];
    player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
    [self presentViewController:player animated:YES completion:nil];
}

//数据持久化到plist文件
- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    return fileName;
}

- (void)stringFromPlist:(NSString *)classid andOther:(NSString *)other
{
    NSString *pathStr = [self getDataFilePath];
    NSLog(@"%@",pathStr);
    if (!pathStr) {
        return;
    }
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    [data addObject:classid];
    [data addObject:other];
    
    [data writeToFile:pathStr atomically:YES];
    
}




#pragma mark - httpRequest
- (void)httpRequestWithStage:(NSString *)classID andClassCode:(NSString *)code andSubject:(NSString *)subject transferNumber:(NSInteger)number
{
    NSString *firstUrl = nil;
    if (number == 0) {
        firstUrl = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkclist&pagesize=100&pageindex=1&key=&jdid=&kch=&nj=";

    } else {
        firstUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkclist&pagesize=10&pageindex=1&key=&jdid=%@&kch=%@&nj=%@",classID, code, subject];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:firstUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"-----data===%@",firstUrl);
        
        if (self.modalDic) {
            [self.modalArr removeAllObjects];
        }
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [self.modalArr removeAllObjects];
            [self.tableView reloadData];
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"FirstVC.plist" andData:responseObject[@"kc_imgurl"]];
        
        self.modalArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            TRSchoolClass *schoolClass = [[TRSchoolClass alloc] init];
            schoolClass.title = dic[@"JCMC"];
            schoolClass.subTitle = dic[@"zpls"];
            //schoolClass.times = dic[@"KCMC"];
            schoolClass.imgUrl = dic[@"KCTP"];
            schoolClass.playerID = dic[@"BKID"];
            [self.modalArr addObject:schoolClass];
        }
        
        [self.modalDic setValue:self.modalArr forKey:@"first"];
        [self.tableView reloadData];
//        [self.tableView headerEndRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error--->%@",error.userInfo);
    }];
}

//获取教育阶段
- (NSArray *)getEducationStage
{
    NSMutableArray *sort = [NSMutableArray array];
    
    NSString *str = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatajd";
    NSString *urlstr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data == nil) {
        return nil;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    for (NSDictionary *params in dic[@"data"]) {
        [self.classID addObject:params[@"ZDBM"]];
        [sort addObject:params[@"ZDMC"]];
    }
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveDataToPlistWithPlistName:@"Stage.plist" andData:self.classID];
    [tools saveDataToPlistWithPlistName:@"StageName.plist" andData:sort];
    return sort;
}

//获取年级 一年级，二年级，三年级。。。。
- (NSArray *)getSmallStageWithIndex:(NSString *)code andIndex:(NSInteger)index
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *httpString = nil;
    if (index == 0) {
        httpString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=004001";
    } else {
        httpString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=%@",code];
    }
   // NSString *codeUrl = [httpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *codeUrl = [httpString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *httpUrl = [NSURL URLWithString:codeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    [self.sortBH removeAllObjects];
    for (NSDictionary *diction in dict[@"data"]) {
        [self.sortBH addObject:diction[@"BH"]];
        [array addObject:diction[@"NJBM"]];
//        NSLog(@"%@",diction[@"BH"]);
    }

    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveDataToPlistWithPlistName:@"BanJiNumber.plist" andData:self.sortBH];
    [tools saveDataToPlistWithPlistName:@"BanJiName.plist" andData:array];
    return array;
}

//获取所有科目
- (NSArray *)getAllSubject
{
    NSMutableArray *subjectArr = [NSMutableArray array];
    
    NSString *urlString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatakm";
//    NSString *codeStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *codeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:codeStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    for (NSDictionary *grade in params[@"data"]) {
        
        [subjectArr addObject:grade[@"KCMC"]];
        [self.subjectCode addObject:grade[@"KCH"]];
    }
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveDataToPlistWithPlistName:@"Subject.plist" andData:self.subjectCode];
    
    
    return subjectArr;
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
