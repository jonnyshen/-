//
//  MYCourseController.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYCourseController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"
#import "MYCourse.h"
#import "MYCourseTableCell.h"
#import "FirstTableViewCellModal.h"
#import "LYPlayerViewController.h"

#define kallUrl @"http://www.quanmin.tv/json/page/appv2-index/info.json?0330152228"

@interface MYCourseController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_userCode;
    NSString *_imageStr;
}
@property (strong, nonatomic)UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *courseArr;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation MYCourseController

- (NSMutableArray *)courseArr
{
    if (!_courseArr) {
        _courseArr = [[NSMutableArray alloc] init];
    }
    return _courseArr;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.tableView.backgroundColor = [UIColor redColor];
    self.title = @"我的课程";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self setUpTableView];
    [self getMyClassHttpRequest];
    //[self ClassHttpRequest];
    [self.tableView addHeaderWithTarget:self action:@selector(getMyClassHttpRequest)];
    [self.tableView headerBeginRefreshing];
}

- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MYCourseTableCell" bundle:nil] forCellReuseIdentifier:@"MYCourseTableCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYCourseTableCell";
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (self.courseArr.count > 0) {
        //MYCourse *course = [MYCourse new];
        MYCourse *course = self.courseArr[indexPath.row];
        [cell setTableViewCellModel:course];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYCourse *course = self.courseArr[indexPath.row];
    LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:course.classID andComeFromWhichVC:@"TWO"];
    player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
    [self presentViewController:player animated:YES completion:nil];
    
}







- (void)getMyClassHttpRequest
{
    [self getDataFilePath];
    //
    NSString *courseURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyxxjl&pagesize=15&pageindex=1&usercode=%@",_userCode];
    NSLog(@"---ass---%@",courseURL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:courseURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (self.dataDic) {
            [self.courseArr removeAllObjects];
        }
        
         NSString* str = [responseObject objectForKey:@"filepath"];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"Course.plist" andData:str];
        
        self.courseArr = [NSMutableArray array];
        for (NSDictionary *param in responseObject[@"data"]) {
            MYCourse *course = [[MYCourse alloc] init];
            course.sumClass = [param[@"SumKs"] stringValue];
            course.editClass = [param[@"XXCount"] stringValue];
            
            course.classID  = param[@"ID"];
            
//            if ([param[@"UserName"] isKindOfClass:[NSNull class]]) {
//                course.className = @"";
//            } else {
                course.teacher = param[@"UserName"];
//            }
            
//            if ([param[@"KCTP"] isKindOfClass:[NSNull class]]) {
//                course.className = @"";
//            } else {
                course.imageStr = param[@"KCTP"];
//            }
            
//            if ([param[@"KCZMC"] isKindOfClass:[NSNull class]]) {
//                course.className = @"";
//            } else {
                course.className = param[@"KCZMC"];
//            }
            
            [self.courseArr addObject:course];
        }
        
        //NSLog(@"===========%@",self.courseArr);
        [self.dataDic setValue:self.courseArr forKey:@"course"];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    

}


- (void)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _userCode = [path objectAtIndex:2];
        
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

@end
