//
//  MoreViewController.m
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "SecondViewController.h"
#import "MoreTableCell.h"
#import "LYPlayerViewController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "HotClassModal.h"
#import "ReconmmandModal.h"

#define kBoolTag [self.tag isEqualToString:@"100"]

//推荐
#define kTJClassUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkclist&pagesize=13&pageindex=1&key=&lbid=&type=tj"

//热门
#define kRMClassUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkclist&pagesize=13&pageindex=1&key=&lbid=&type=rm"


@interface MoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSString* tag;
@property(nonatomic , strong) NSMutableArray  *tempArrA;
@property(nonatomic , strong) NSMutableArray  *tempArrB;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MoreViewController

- (instancetype)initWithButtonTag:(NSString *)tag
{
    self = [super init];
    if (self) {
        self.tag = tag;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpTableView];
    
    [self getMoreClassHttp];
    
    [self.tableView addFooterWithTarget:self action:@selector(getMoreClassHttp)];
    
}

- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    //self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreTableCell" bundle:nil] forCellReuseIdentifier:@"MoreTableCell"];
}




- (void)getMoreClassHttp
{
    
    NSLog(@"%@",self.tag);
     MYToolsModel *tools = [[MYToolsModel alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if ([self.tag isEqualToString:@"100"]) {
        
        //热门课程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [manager GET:kRMClassUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                //NSLog(@"CLASS---->%@",responseObject);
                
                
                NSString *imageStr = responseObject[@"kc_imgurl"];
                [tools saveToPlistWithPlistName:@"HotClass.plist" andData:imageStr];
                
                
                self.tempArrA = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    HotClassModal *hot = [[HotClassModal alloc] init];
                    hot.title = dic[@"KCMC"];
                    hot.imgUrl = dic[@"KCTP"];
                    hot.userName = dic[@"UserName"];
                    hot.openClassID = dic[@"KCID"];
                    hot.classesNum = [dic[@"kscount"] stringValue];
                    hot.classesEnd = [dic[@"xxcount"] stringValue];
                    [self.tempArrA addObject:hot];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView footerEndRefreshing];
                });
        
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                NSLog(@"hot error---%@",error.userInfo);
                
            }];
        });
        
    } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [manager GET:kTJClassUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                NSLog(@"CLASS---->%@",responseObject);
                
                NSString *imageStr = responseObject[@"kc_imgurl"];
                [tools saveToPlistWithPlistName:@"RecommendClass.plist" andData:imageStr];
                
                self.tempArrB = [NSMutableArray array];
               
                for (NSDictionary *dic in responseObject[@"data"]) {
                    ReconmmandModal *reconmmand = [[ReconmmandModal alloc]init];
    
                    reconmmand.title = dic[@"KCMC"];
                    reconmmand.imgUrl = dic[@"KCTP"];
                    reconmmand.openClassID = dic[@"KCID"];
                    reconmmand.userName = dic[@"UserName"];
                    reconmmand.number = dic[@"kscount"];
                    reconmmand.people = dic[@"xxcount"];
                    
                    [self.tempArrB addObject:reconmmand];
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView footerEndRefreshing];
                });
                
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                NSLog(@"reconmmand error---%@",error.userInfo);
                
            }];
        });

    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tag isEqualToString:@"100"]) {
        return self.tempArrA.count;
    } else {
        return self.tempArrB.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MoreTableCell";
    
    MoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (kBoolTag) {
        if (self.tempArrA.count > 0) {
            HotClassModal *hotModel = self.tempArrA[indexPath.row];
            [cell setTableViewCellModel:hotModel];
        }
    } else {
        if (self.tempArrB.count > 0) {
            ReconmmandModal *recomm = self.tempArrB[indexPath.row];
            [cell setRecommendTableCell:recomm];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (kBoolTag) {
        HotClassModal *hot = self.tempArrA[indexPath.row];
        NSString *playerID = hot.openClassID;
        LYPlayerViewController *player = [[LYPlayerViewController alloc]initWithVideoId:playerID andComeFromWhichVC:@"TWO"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
    } else {
        
        ReconmmandModal *recommand = self.tempArrB[indexPath.row];
        NSString *RePlayerID = recommand.openClassID;
        LYPlayerViewController *player = [[LYPlayerViewController alloc]initWithVideoId:RePlayerID andComeFromWhichVC:@"TWO"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
        
    }
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //when当前对象被释放，需要注销掉消息通知
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    SecondViewController *second = [[SecondViewController alloc] init];
    
    self.tag = second.btnTag;
    
    
}

@end
