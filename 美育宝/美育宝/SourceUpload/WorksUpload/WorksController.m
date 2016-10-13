//
//  WorksController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "WorksController.h"
#import "WorksOneMode.h"
#import "WorksCell.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"
#import "SkimController.h"
#import "ClassifiedWorksUploadCon.h"
#import "UploadWorksDisplayController.h"


@interface WorksController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *imgurl;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *worksDataArr;
@end

@implementation WorksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"作品上传";
    [self httpRequest];
    
    
    [self setUpTableView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemReply) target:self action:@selector(uploadTasksData)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}



- (void)setUpTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView = table;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WorksCell" bundle:nil] forCellReuseIdentifier:@"WorksCell"];
}

- (void)httpRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=1000&pageindex=1&xh=&bh=&isgood=0" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        imgurl = responseObject[@"imgurl"];
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"WorksUpload.plist" andData:imgurl];
        
        for (NSDictionary *params in responseObject[@"aaData"]) {
            WorksOneMode *model = [WorksOneMode dataWithDict:params];
            [self.worksDataArr addObject:model];
        }
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.worksDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"WorksCell";
    WorksCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    WorksOneMode *worksData = self.worksDataArr[indexPath.row];
    cell.worksData = worksData;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
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
    [self.worksDataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    WorksOneMode *model = self.worksDataArr[indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=deldx&dxid=%@",model.mxdm] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            //            [FormValidator showAlertWithStr:@"删除成功"];
        } else {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WorksOneMode *oneModel = self.worksDataArr[indexPath.row];
    NSString *photoStr = [self pieceOfString:oneModel.imgPath];
    
    NSMutableDictionary *dataArr = [NSMutableDictionary dictionary];
    [dataArr setValue:photoStr forKey:@"photostr"];
    [dataArr setValue:oneModel.fjmc forKey:@"fjmc"];
    [dataArr setValue:oneModel.mxdm forKey:@"mxdm"];
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveToPlistWithPlistName:@"SkitData.plist" andDict:dataArr];
    
    SkimController *skit = [[SkimController alloc] init];

    [self.navigationController pushViewController:skit animated:YES];
}

- (NSString *)pieceOfString:(NSString*)imageStr
{
    
    NSString *pictureStr = nil;
    if (imageStr.length > 0) {
        NSString *pieceStr = [imageStr substringWithRange:NSMakeRange(0, 6)];
        pictureStr = [NSString stringWithFormat:@"%@%@/%@",imgurl, pieceStr, imageStr];
    }
    return pictureStr;
}


- (void)uploadTasksData
{
    
    UploadWorksDisplayController *sourceDisplay = [[UploadWorksDisplayController alloc] init];
    [self.navigationController pushViewController:sourceDisplay animated:YES];
    
    
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


- (NSMutableArray *)worksDataArr
{
    if (!_worksDataArr) {
        _worksDataArr = [[NSMutableArray alloc] init];
    }
    return _worksDataArr;
}

@end
