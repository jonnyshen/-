//
//  DirectionViewController.m
//  Page Demo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DirectionViewController.h"
#import "directionModel.h"
#import "MYSubTitle.h"
#import "MYToolsModel.h"

#import "SKSTableView.h"
#import "SKSTableViewCell.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "FormValidator.h"

#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define kAddViewX kView_H - 20- 200 - 70 - 49

@interface DirectionViewController ()<WSTableViewDelegate>
{
//    课程ID
    NSString *_classID;
    NSString *_open;
}

@property (nonatomic, strong) NSArray *contents;

@property (nonatomic, strong) NSMutableArray *dataSourceArrM;

@property (nonatomic, strong) WSTableView *tableView;//伸缩的tableview

@property (nonatomic, strong)NSMutableArray *tempArr;

@property (nonatomic, strong) NSMutableArray *tempArray;

@end

@implementation DirectionViewController

- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}

- (NSMutableArray *)tempArr
{
    if (!_tempArr) {
        _tempArr = [NSMutableArray array];
    }
    return _tempArr;
}

//- (NSArray *)dataSourceArrM
//{
//    if (!_dataSourceArrM) {
//        MYToolsModel *tools = [[MYToolsModel alloc] init];
//        _dataSourceArrM =    [tools getDataArrayFromPlist:@"DirecionCon.plist"];
//    }
//    return _dataSourceArrM;
//}

/*
- (NSArray *)contents
{
    if (!_contents) {
        
        NSInteger titleCount    = self.tempArr.count;
        NSInteger subTitleCount = self.tempArray.count;
        for (int i = 0; i < titleCount; i++) {
            directionModel *direct  = self.tempArr[i];
            NSString *string = direct.directionName;
        }
        
        
        //directionModel *direct = self.tempArr[]
        _contents = @[@[@[@"Section0_Row0",@"Row0_Subrow1",@"Row0_Subrow2"],                 @[@"Section0_Row1",@"Row1_Subrow1",@"Row1_Subrow2"],
            @[@"Section0_Row2"]]];
        
    }
    
    return _contents;
}

*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
   
    
    [self sendTitleArray:self.tempArr andSubTitleArr:self.tempArray];
    
        self.tableView = [[WSTableView alloc] initWithFrame:CGRectMake(0, 0, kView_W, kAddViewX)];
        [self.view addSubview:self.tableView];
    self.tableView.WSTableViewDelegate = self;
    
   
   
    
}


- (void)getClassNameData
{
    if (!_classID) {
        _classID = [self getDataFilePath];
    }
    
    NSString *url = nil;
    if ([_open isEqualToString:@"OPEN"]) {
        url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkcinfo&kcid=%@",_classID];
    } else {
        url  = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=%@", _classID];
    }
    
    
    NSLog(@"dorectionviewcontroller===%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        self.tempArr   = [NSMutableArray array];
        self.tempArray = [NSMutableArray array];
        if ([responseObject[@"ZJML"] isKindOfClass:[NSString class]]) {
            return;
        }
        for (NSDictionary *dic in responseObject[@"ZJML"]) {
            directionModel *direction = [[directionModel alloc] init];
            direction.directionName = dic[@"BT"];
            [self.tempArr addObject:direction];
            NSArray *arrParam = dic[@"KS"];
            for (NSDictionary *param in arrParam) {
                MYSubTitle *subTitle = [[MYSubTitle alloc] init];
                subTitle.directionNickName = param[@"KSMC"];
                subTitle.videoFilePath = param[@"filePath"];
                [self.tempArray addObject:subTitle];
            }
            
            
        }
        
 
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"借记卡--%@",error.userInfo);
    }];

    
}

- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _classID = [path objectAtIndex:0];
        _open    = [path objectAtIndex:1];
    }
    
    return _classID;
}

- (void)sendTitleArray:(NSArray *)titleArr andSubTitleArr:(NSArray *)subTitleArr
{
        
        if (!_classID) {
//            如果课程ID为空，从plist文件获取
            _classID = [self getDataFilePath];
        }
    NSString *url = nil;
    /**
     open是一个标示，主要用来标示不同的获取视频信息的方法
     */
    if ([_open isEqualToString:@"OPEN"]) {
        url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkcinfo&kcid=%@",_classID];
    } else {
        url  = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=%@", _classID];
    }
    
        NSString *codeStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *urlString = [NSURL URLWithString:codeStr];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        
        NSArray *textArr = dictionary[@"ZJML"];
        if ([textArr.firstObject isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无播放数据"];
            return;
        }
    
     NSMutableArray *subMessageArr = [NSMutableArray array];
    for (NSDictionary *params in dictionary[@"ZJML"]) {
        
        [self.tempArr addObject:params[@"BT"]];
        
        NSArray *arrParam = params[@"KS"];
        
        if ([arrParam isKindOfClass:[NSNull class]] ||!arrParam) {
            
        } else {
            [subMessageArr addObject:arrParam];
        }
        
    }
    
   
    /**
     把上面获取到的数据，赋值到WSTableview
     */
    
    _dataSourceArrM = [NSMutableArray array];
    NSMutableArray *filePathArr = [NSMutableArray array];
    for (int i = 0; i < self.tempArr.count; i++) {
        WSTableviewDataModel *dataModel = [[WSTableviewDataModel alloc] init];
        dataModel.firstLevelStr = self.tempArr[i];
        dataModel.shouldExpandSubRows = YES;
        if (subMessageArr.count > i) {
            for (NSDictionary *dict in subMessageArr[i]) {
                
                [dataModel object_add_toSecondLevelArrM:dict[@"KSMC"]];
                
                [filePathArr addObject:dict[@"filePath"]];
                
                
            }
        }
        [self.tempArray addObject:filePathArr];
        
        [_dataSourceArrM addObject:dataModel];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrM count];
    
}

- (NSInteger)tableView:(WSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    WSTableviewDataModel *dataModel = _dataSourceArrM[indexPath.row];
    return [dataModel.secondLevelArrM count];
}

- (BOOL)tableView:(WSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    WSTableviewDataModel *dataModel = _dataSourceArrM[indexPath.row];
    return dataModel.shouldExpandSubRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSTableviewDataModel *dataModel = _dataSourceArrM[indexPath.row];
    static NSString *CellIdentifier = @"WSTableViewCell";
    
    WSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[WSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = dataModel.firstLevelStr;
    
    cell.expandable = dataModel.expandable;
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSTableviewDataModel *dataModel = _dataSourceArrM[indexPath.row];
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [dataModel object_get_fromSecondLevelArrMWithIndex:indexPath.subRow];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(WSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - WSTableview 的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WSTableviewDataModel *dataModel = _dataSourceArrM[indexPath.row];
    dataModel.shouldExpandSubRows = !dataModel.shouldExpandSubRows;
    
    NSLog(@"Section: %ld, Row:%ld", indexPath.section, indexPath.row);
    
}

- (void)tableView:(WSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", indexPath.section, indexPath.row, indexPath.subRow);
    
    NSString *videoPath = self.tempArray[indexPath.row][indexPath.subRow];//直接取得视频URL
    
    NSDictionary *noticDict = [NSDictionary dictionaryWithObjectsAndKeys:videoPath,@"videoPath", nil];
    NSNotification *notic = [NSNotification notificationWithName:@"WSTableView_FILE_PATH" object:nil userInfo:noticDict];
    [[NSNotificationCenter defaultCenter] postNotification:notic];
}

#pragma mark - Actions

//- (void)collapseSubrows
//{
//    [self.tableView collapseCurrentlyExpandedIndexPaths];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    NSLog(@"--------->>>%@",cell.textLabel.text);
    
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
        cell.isExpandable = YES;
    else
        cell.isExpandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    cell.textLabel.text = @"goodboy";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"=========%@",cell.textLabel.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld,subrow=%ld",(long)indexPath.section,(long)indexPath.row);
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
