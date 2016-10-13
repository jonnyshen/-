//
//  SourceController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SourceController.h"
#import "SourceData.h"
#import "SourceUploadCell.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"
#import "SkimController.h"
#import "UploadController.h"
#import "UploadSourceDisplayController.h"
#import "ClassifiedWorksUploadCon.h"


@interface SourceController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *imgurl;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *worksDataArr;
@end

@implementation SourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资源";
    
     [self httpRequest];
    
    
    [self setUpTableView];
    
   
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemReply) target:self action:@selector(uploadTasksData)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    [self.navigationItem setLeftBarButtonItem:addBtn];
    
}

- (void)clickBackBtn
{
//    UploadController *source = [[UploadController alloc] init];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
        NSArray *array = self.navigationController.viewControllers;
    
        for (UIViewController *controller in array) {
            if ([controller isKindOfClass:[UploadController class]]) {
                UploadController *source = (UploadController *)controller;
                [self.navigationController popToViewController:source animated:YES];
            }
        }

}


- (void)setUpTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView = table;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SourceUploadCell" bundle:nil] forCellReuseIdentifier:@"SourceUploadCell"];
}

- (void)httpRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzylist&jd=&nj=1&km=150101&jcdm=&dybh=&zbh=&ucode=&lb=&orderBy=&pageindex=&pagesize=" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        imgurl = responseObject[@"imgurl"];
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"WorksUpload.plist" andData:imgurl];
        
        for (NSDictionary *params in responseObject[@"data"]) {
            SourceData *model = [SourceData dataWithDict:params];
            [self.worksDataArr addObject:model];
        }
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.worksDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SourceUploadCell";
    SourceUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    SourceData *worksData = self.worksDataArr[indexPath.row];
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
    
    SourceData *model = self.worksDataArr[indexPath.row];
    
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
    
    SourceData *oneModel = self.worksDataArr[indexPath.row];
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
    
    UploadSourceDisplayController *sourceDisplay = [[UploadSourceDisplayController alloc] init];
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
