//
//  MYCollectController.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYCollectController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "FirstTableViewCellModal.h"
#import "MYCollect.h"
#import "MYToolsModel.h"
#import "MYCollectTableCell.h"
#import "MYSunCount.h"
#import "FormValidator.h"
#import "MYMakeUpCompleteString.h"
#import "DetailTextViewController.h"
#import "LYPlayerViewController.h"
#import "QuestionAndAnswerCon.h"

@interface MYCollectController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_userCode;
    NSString *sourcePath;
    NSString *kcPath;
    NSString *docPath;
}
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *collectArr;
@end

@implementation MYCollectController

- (NSMutableArray *)collectArr
{
    if (!_collectArr) {
        _collectArr = [[NSMutableArray alloc] init];
    }
    return _collectArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self setTableViewStyle];
    
    [self httpRequest];
    
    [self.tableView addHeaderWithTarget:self action:@selector(httpRequest)];

}

- (void)setTableViewStyle
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MYCollectTableCell" bundle:nil] forCellReuseIdentifier:@"MYCollectTableCell"];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.collectArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYCollectTableCell";
    
    MYCollectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
        if (self.collectArr.count > 0) {
            MYCollect *collect = self.collectArr[indexPath.row];
        [cell setTableCellModel:collect];
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
    
    MYCollect *collect = self.collectArr[indexPath.row];
    
    if ([collect.imageType isEqualToString:@"2"] ||[collect.imageType isEqualToString:@"4"] ||[collect.imageType isEqualToString:@"5"]||[collect.imageType isEqualToString:@"6"]) {
       NSString *kcSource = [MYMakeUpCompleteString handleWithHeaderImage:collect.imageStr headStr:kcPath];
        if ([kcSource.pathExtension isEqualToString:@"jpg"] || [kcSource.pathExtension isEqualToString:@"png"] || [kcSource.pathExtension isEqualToString:@"gif"]) {
            
            DetailTextViewController *detail = [[DetailTextViewController alloc] initWithImageString:kcSource commemtID:collect.collectClassID from:@" " title:collect.className];
            [self.navigationController pushViewController:detail animated:YES];
            
        } else {
            
            LYPlayerViewController *playerVC = [[LYPlayerViewController alloc] initWithVideoURL:kcSource videoID:collect.collectClassID andComeFromWhichVC:@"TWO"];
            playerVC = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
            [self presentViewController:playerVC animated:YES completion:nil];
            
        }
        
        
    } else if ([collect.imageType isEqualToString:@"1"] || [collect.imageType isEqualToString:@".jpg"] ||[collect.imageType isEqualToString:@".flv"] ||[collect.imageType isEqualToString:@".avi"]||[collect.imageType isEqualToString:@".mp4"]||[collect.imageType isEqualToString:@".png"] ||[collect.imageType isEqualToString:@".gif"]) {
        
        NSString *source = [MYMakeUpCompleteString handleWithHeaderImage:collect.imageStr headStr:sourcePath];
        if ([source.pathExtension isEqualToString:@"jpg"] || [source.pathExtension isEqualToString:@"png"] || [source.pathExtension isEqualToString:@"gif"]) {
            
            DetailTextViewController *detail = [[DetailTextViewController alloc] initWithImageString:source commemtID:collect.collectClassID from:@" " title:collect.className];
            [self.navigationController pushViewController:detail animated:YES];
            
        } else {
            
            LYPlayerViewController *playerVC = [[LYPlayerViewController alloc] initWithVideoURL:source videoID:collect.collectClassID andComeFromWhichVC:@"TWO"];
            [self presentViewController:playerVC animated:YES completion:nil];
            
        }
    } else {
//        NSString *docSource = [MYMakeUpCompleteString handleWithHeaderImage:collect.imageStr headStr:docPath];
        
        QuestionAndAnswerCon *question = [[QuestionAndAnswerCon alloc] initWithQuestionID:collect.collectClassID];
        [self.navigationController pushViewController:question animated:YES];
        
    }
    
}


- (void)httpRequest
{
    [self getDataFilePath];
    //R000000003
    NSString *url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmysc&pagesize=15&pageindex=1&usercode=%@",_userCode];
    
    MYSunCount *sumcount = [[MYSunCount alloc] init];
    NSInteger count = [sumcount requestForAcountSum:@"sumcount" requestURL:url];
    NSString *collect_ConUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmysc&pagesize=%ld&pageindex=1&usercode=%@",count, _userCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:collect_ConUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        sourcePath = [responseObject objectForKey:@"zy_imgurl_files"];
        docPath = [responseObject objectForKey:@"zy_imgurl_doc"];
        kcPath = [responseObject objectForKey:@"kc_imgurl"];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:sourcePath, docPath, kcPath, nil];
        
        [tools saveDataToPlistWithPlistName:@"Collect.plist" andData:array];
        
        for (NSDictionary *param in responseObject[@"data"]) {
            MYCollect *collect = [[MYCollect alloc] init];
            collect.teacher    = param[@"UserName"];
            collect.className  = param[@"infotitle"];
            collect.imageStr   = param[@"infoimg"];
            collect.collectClassID = param[@"ID"];
            collect.imageType  = [param[@"GLLX"] stringValue];
            [self.collectArr addObject:collect];
        }
//        NSLog(@"%@",self.collectArr);
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
