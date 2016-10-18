//
//  LYThreeViewController.m
//  Page Demo
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYThreeViewController.h"
#import "AMapViewController.h"
#import "ZDJingXuanTopHeadView.h"
#import "MYJingXuanHeaderView.h"
#import "LoginViewController.h"
#import "LYDaoXueTabBarViewController.h"
#import "LoginState.h"
#import "ThrSetUpController.h"
#import "MYExerciseViewController.h"
#import "MYClassCenterTabController.h"
#import "WorksTabBarController.h"
#import "MYSchoolMessageController.h"
#import "MyRedFlowerViewController.h"
#import "SchoolReportController.h"
#import "MYToolsModel.h"
//#import "AboutMeiYuController.h"
#import "TeacherShowWorksController.h"
#import "StudentDaoXueController.h"
#import "SourceController.h"
#import "WorksController.h"
#import "UploadController.h"


#define ButtonTagA 100
#define ButtonTagB 101
#define ButtonTagC 102
#define ButtonTagD 103
#define ButtonTagE 104

@interface LYThreeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)ZDJingXuanTopHeadView *headerView;
@property (nonatomic, strong) MYJingXuanHeaderView *stuHeaderView;

@property (nonatomic, copy)NSArray *titles1;
@property (nonatomic, copy)NSArray *images1;
@property (nonatomic, copy)NSArray *titles2;
@property (nonatomic, copy)NSArray *images2;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) MYToolsModel *tools;

@end

@implementation LYThreeViewController

- (NSArray *)titles1 {
    if (!_titles1) {
        _titles1 = @[@"我的学习",@"课前导学",@"课外活动",@"作品展示"];
    }
    return _titles1;
}
- (NSArray *)titles2 {
    if (!_titles2) {
        _titles2 = @[@"上传",@"设置",@""];
    }
    return _titles2;
}
-(NSArray *)images1 {
    if (!_images1) {
        _images1 = @[@"learn_history.png",@"guidance_lea.png",@"my_photo_album.png",@"work_show.png"];
    }
    return _images1;
}


-(NSArray *)images2 {
    if (!_images2) {
        _images2 = @[@"help_feedback.png",@"set.png",@""];
    }
    return _images2;
}

- (ZDJingXuanTopHeadView *)headerView
{
    if (!_headerView) {
        _headerView = [ZDJingXuanTopHeadView jingXuanTopHeadView];
        __weak typeof(self) weakSelf = self;
        _headerView.jingPinBtnClickBlock = ^(NSInteger index){
            
            NSLog(@"点击了产品推荐按钮%ld",(long)index);
            
            if (index == ButtonTagE) {
                LoginViewController *login = [[LoginViewController alloc] init];
                login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [weakSelf.navigationController pushViewController:login animated:YES];
            } else if (index == ButtonTagC){
//                学校公告
                MYSchoolMessageController *schoolCon = [[MYSchoolMessageController alloc] init];
                [weakSelf.navigationController pushViewController:schoolCon animated:YES];
                
                
            } else if (index == ButtonTagA) {
//                小红花
                MyRedFlowerViewController *redFlower = [[MyRedFlowerViewController alloc] init];
                [weakSelf.navigationController pushViewController:redFlower animated:YES];
                
            } else if (index == ButtonTagB) {
                //学期报告
                SchoolReportController *schoolReport = [[SchoolReportController alloc] init];
                [weakSelf.navigationController pushViewController:schoolReport animated:YES];
                
            }
            
            else {
                [LoginViewController login:weakSelf loginType:LoginType_Normal];
                
                //地图定位
                AMapViewController *jumpVc = [[AMapViewController alloc] init];
                
                [weakSelf.navigationController pushViewController:jumpVc animated:YES];
            }
            
        };
    }
    return _headerView;
}

/*
- (MYJingXuanHeaderView *)stuHeaderView
{
    if (!_stuHeaderView) {
        _stuHeaderView = [MYJingXuanHeaderView StudentJingXuanHeaderView];
        
        __weak typeof(self) stuWeakself = self;
        _stuHeaderView.StudentJingXuanHeaderView = ^(NSInteger stuindex) {
            
            if (stuindex == ButtonTagA) {
                LoginViewController *login = [[LoginViewController alloc] init];
                login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [stuWeakself.navigationController pushViewController:login animated:YES];
            } else if (stuindex == ButtonTagB) {
                MyRedFlowerViewController *redFlower = [[MyRedFlowerViewController alloc] init];
                [stuWeakself.navigationController pushViewController:redFlower animated:YES];
            } else if (stuindex == ButtonTagC) {
                
                MYSchoolMessageController *schoolCon = [[MYSchoolMessageController alloc] init];
                schoolCon = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"MYSchoolMessageController"];
                [stuWeakself.navigationController pushViewController:schoolCon animated:YES];
                
            } else if (stuindex == ButtonTagD) {
                [LoginViewController login:stuWeakself loginType:LoginType_Normal];
                
                //根据index，取出对应的模型，跳转控制器，显示网页
                AMapViewController *jumpVc = [[AMapViewController alloc] init];
                
                [stuWeakself.navigationController pushViewController:jumpVc animated:YES];
            }
            
            
        };
        
    }
    return _stuHeaderView;
}

*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        self.accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
        [self.navigationController setNavigationBarHidden:NO];
        
        if (self.accountType == nil) {
            //第一次登陆
            //        self.headerView.studentViewOne.hidden = NO;
            //        self.headerView.studentViewTwo.hidden = NO;
            //        self.headerView.teacherView.hidden = YES;
            
        } else {
            //        已登陆
            
            
            if ([self.accountType isEqualToString:@"0"] || [self.accountType isEqualToString:@"2"]) {
                //            学生或家长登陆
                self.headerView.teacherView.hidden = YES;
                self.headerView.studentViewOne.hidden = NO;
                self.headerView.studentViewTwo.hidden = NO;
                
            } else {
                //            老师登陆
                self.headerView.teacherView.hidden = NO;
                self.headerView.studentViewOne.hidden = YES;
                self.headerView.studentViewTwo.hidden = YES;
            }
        }
        

    }
    return self;
}




/*
- (void)loadView{
    [super loadView];
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    self.accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
    [self.navigationController setNavigationBarHidden:NO];

    if (self.accountType == nil) {
        //第一次登陆
//        self.headerView.studentViewOne.hidden = NO;
//        self.headerView.studentViewTwo.hidden = NO;
//        self.headerView.teacherView.hidden = YES;
        
    } else {
//        已登陆
        
        
        if ([self.accountType isEqualToString:@"0"] || [self.accountType isEqualToString:@"2"]) {
//            学生或家长登陆
            self.headerView.teacherView.hidden = YES;
            self.headerView.studentViewOne.hidden = NO;
            self.headerView.studentViewTwo.hidden = NO;
           
        } else {
//            老师登陆
            self.headerView.teacherView.hidden = NO;
            self.headerView.studentViewOne.hidden = YES;
            self.headerView.studentViewTwo.hidden = YES;
                    }
    }
    
   
}
*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *LoginName = [tools sendFileString:@"LoginData.plist" andNumber:6];
    self.accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
    
    if (self.accountType == nil) {
        //第一次登陆
        [self.headerView.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        
        self.headerView.loginBtn.userInteractionEnabled = YES;
    } else {
        //        已登陆
        
        
        if ([self.accountType isEqualToString:@"0"] || [self.accountType isEqualToString:@"2"]) {
            //            学生或家长登陆
           
            if ([LoginState isLogin]) {
                [self.headerView.loginBtn setTitle:LoginName forState:UIControlStateNormal];
                self.headerView.loginBtn.userInteractionEnabled = NO;
            }
            else{
                [self.headerView.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
                self.headerView.loginBtn.userInteractionEnabled = YES;
            }
        } else {
            //            老师登陆
        
            if ([LoginState isLogin]) {
                [self.stuHeaderView.StuLoginBtn setTitle:LoginName forState:UIControlStateNormal];
                self.headerView.loginBtn.userInteractionEnabled = NO;
            }
            else{
                [self.stuHeaderView.StuLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
                self.headerView.loginBtn.userInteractionEnabled = YES;
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setUpTableView];
    
    //老师登录时执行
    NSString *loginType = [self.tools sendFileString:@"LoginData.plist" andNumber:5];
    if ([loginType isEqualToString:@"1"] || [loginType isEqualToString:@"0"]) {
        [self getTeacherClass];
    }
    
    
}

//老师登录时执行，把老师带的班级存到plist
- (void)getTeacherClass
{
    NSMutableArray *classify = [[NSMutableArray alloc] init];
    NSMutableArray *classifyID = [[NSMutableArray alloc] init];
    self.tools = [[MYToolsModel alloc] init];
    NSString *loginCode = [self.tools sendFileString:@"LoginData.plist" andNumber:0];
    
    NSString *logincodeUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyclass&logincode=%@",loginCode];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:logincodeUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data == nil) {
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
            return;
        }
        
        for (NSDictionary *params in dict[@"data"]) {
            
            if ([params[@"BJMC"] isKindOfClass:[NSNull class]]) {
                [classify addObject:@" "];
            } else {
                [classify addObject:params[@"BJMC"]];
            }
            
            
            [classifyID addObject:params[@"BJH"]];
        }
        
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [filePath objectAtIndex:0];
        
        NSString *fileName = [documentPath stringByAppendingPathComponent:@"TeacherClass.plist"];
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        
        
        [dataArr addObject:classify];
        [dataArr addObject:classifyID];
        
        [dataArr writeToFile:fileName atomically:YES];
        
        }];
    [dataTask resume];
}

//屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)setUpTableView
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    UIView *view;

        view = [[UIView alloc]initWithFrame:self.headerView.frame];
        [view addSubview:self.headerView];
        self.tableView.tableHeaderView = view;
        

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"PersonCenterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:self.images1[indexPath.row]];
            cell.textLabel.text = self.titles1[indexPath.row];
        } else {
            cell.imageView.image = [UIImage imageNamed:self.images2[indexPath.row]];
            cell.textLabel.text = self.titles2[indexPath.row];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tools = [[MYToolsModel alloc] init];
    NSString *loginType = [self.tools sendFileString:@"LoginData.plist" andNumber:5];
    
    
    if ([LoginState isLogin]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                //课程中心
                MYClassCenterTabController *classCenter = [[MYClassCenterTabController alloc] init];
                [self.navigationController pushViewController:classCenter animated:YES];
                
                
            } else if (indexPath.row == 1) {
//                课前导学
                if ([loginType isEqualToString:@"2"]) {
                    StudentDaoXueController *studentTabBar = [[StudentDaoXueController alloc] init];
                    [self.navigationController pushViewController:studentTabBar animated:YES];
                } else {
                    LYDaoXueTabBarViewController *tabBarCon = [[LYDaoXueTabBarViewController alloc] init];
                    [self.navigationController pushViewController:tabBarCon animated:YES];
                }
               
                
            } else if (indexPath.row == 2) {
                
                MYExerciseViewController *exercise = [[MYExerciseViewController alloc] init];

                [self.navigationController pushViewController:exercise animated:YES];
            } else {
                
                if ([loginType isEqualToString:@"2"]) {
                    WorksTabBarController *showWorks = [[WorksTabBarController alloc] init];

                    [self.navigationController pushViewController:showWorks animated:YES];
                } else {
                    TeacherShowWorksController *teacher = [[TeacherShowWorksController alloc] init];
                    [self.navigationController pushViewController:teacher animated:YES];
                }
                
                               
            }
            
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                ThrSetUpController *logOut = [[ThrSetUpController alloc] init];
                [self.navigationController pushViewController:logOut animated:YES];
            } else  {
                
               
                if ([loginType isEqualToString:@"2"]) {
                    WorksController *works = [[WorksController alloc] init];
                    [self.navigationController pushViewController:works animated:YES];
                } else {
                    UploadController *upload = [[UploadController alloc] init];
                    [self.navigationController pushViewController:upload animated:YES];
                }
                
            }
            
        }
    } else {
        [LoginViewController login:self loginType:LoginType_Normal];
    }
    
    
}

- (MYToolsModel *)tools
{
    if (!_tools) {
        _tools = [[MYToolsModel alloc] init];
    }
    return _tools;
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
