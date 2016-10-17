//
//  CommentViewController.m
//  Page Demo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "CommentViewController.h"
#import "LYOneViewController.h"
#import "LoginViewController.h"
#import "CommentTableViewCell.h"
#import "TRCommentTableViewCell.h"
#import "FirstTableViewCellModal.h"
#import "CommentCellModel.h"
#import "TRCommentModel.h"
#import "MYToolsModel.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "FormValidator.h"

#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define kAddViewX kView_H - 20- 200 - 70 - 49

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,NSURLSessionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tempArrA;
@property (nonatomic, strong) NSMutableArray *tempArrB;

@property (nonatomic, strong) NSString *classID;


@end

@implementation CommentViewController

- (NSMutableArray *)tempArrA
{
    if (!_tempArrA) {
        _tempArrA = [[NSMutableArray alloc] init];
    }
    return _tempArrA;
}
- (NSMutableArray *)tempArrB
{
    if (!_tempArrB) {
        _tempArrB = [[NSMutableArray alloc] init];
    }
    return _tempArrB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self httpRequest];
    
    [self setUpTableView];
    
    

    [self.tableView addFooterWithTarget:self action:@selector(httpRequest)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentNotificationRefresh:) name:@"comment" object:nil];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
}

- (void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCommentNotificationRefresh:(NSNotification *)notic
{
    
    [self httpRequest];
}

- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kView_H);
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"Comment"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TRCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"TRComment"];
}

#pragma mark - UITbaleViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
    }
    return self.tempArrA.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = @"Comment";
    } else {
        cellID = @"TRComment";
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        //CommentCellModel *comment = self.tempArrA[indexPath.row];
        CommentCellModel *comment = [CommentCellModel new];
        [cell setTableViewCellModel:comment];
        
        
    } else {
        TRCommentModel *trComment = self.tempArrA[indexPath.row];
        //TRCommentModel *trComment = [TRCommentModel new];
        [cell setTableViewCellModel:trComment];
        cell.userInteractionEnabled = NO;
    }
    return cell;
    */
    
    if (indexPath.section == 0) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
        if (!cell) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Comment"];
            CommentCellModel *comment = [CommentCellModel new];
            [cell setTableViewCellModel:comment];
            
        }
        return cell;
    } else {
        
        TRCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRComment" forIndexPath:indexPath];
        [cell.deleCommentBtn addTarget:self action:@selector(deleCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        TRCommentModel *trComment = self.tempArrA[indexPath.row];
       
        cell.obj = trComment;
//        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - httpRequest获取评论数据
- (void)httpRequest
{
    if (!self.classID) {
         [self getDataFilePath];
    }
   
    
    NSString *commentUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcpl&kcid=%@", self.classID];
//    NSLog(@"comment----------------+++++++%@",commentUrl);
    
    NSString *codeString = [commentUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:codeString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        id sumcount =  [responseObject objectForKey:@"KCPL"];
        if ([sumcount isKindOfClass:[NSString class]]) {
            return;
        } else {
            self.tempArrA = [NSMutableArray array];
            for (NSDictionary *param in responseObject[@"KCPL"]) {
                TRCommentModel *commModel = [[TRCommentModel alloc] init];
                commModel.imageUrl = param[@"PersonImage"];
                commModel.teacherName = param[@"UserName"];
                commModel.time = param[@"CJSJ"];
                commModel.detailComment = param[@"PJMS"];
                commModel.rank = param[@"PJDJ"];
                commModel.commentId = param[@"ID"];
                [self.tempArrA addObject:commModel];
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        }
    }];
    [dataTask resume];

    
}


//从plist文件获取登录信息
- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        self.classID = [path objectAtIndex:0];
        
    }
    
    return self.classID;
}


//评论删除
- (void)deleCommentBtnClick:(UIButton *)btn
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"删除笔记" message:@"亲，删除之后将再也看不到了哦！" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *concertBtn = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell *)[[btn superview] superview]];
        [self deleteButtonAction:index.row];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:concertBtn];
    [alertControl addAction:cancelBtn];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)deleteButtonAction:(NSInteger)index
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *_userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *_passWord = [tools sendFileString:@"LoginData.plist" andNumber:1];
    
    TRCommentModel *commModel = self.tempArrA[index];
    NSString *deleUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=delpl&ucode=%@&upwd=%@&id=%@",_userCode, _passWord,commModel.commentId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:deleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            [self httpRequest];
            
            [FormValidator showAlertWithStr:@"已删除！"];
        } else {
            [FormValidator showAlertWithStr:@"删除失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"网络开小差，请稍等！"];
    }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CommentTableViewCell *textcell = [[CommentTableViewCell alloc] init];
    [textcell.commentText resignFirstResponder];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
