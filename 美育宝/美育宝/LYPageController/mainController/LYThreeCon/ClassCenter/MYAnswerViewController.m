//
//  MYAnswerViewController.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYAnswerViewController.h"
#import "FirstTableViewCellModal.h"
#import "AFNetworking.h"
#import "MYAnwser.h"
#import "MJRefresh.h"
#import "QuestionAndAnswerCon.h"
#import "FormValidator.h"

@interface MYAnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_userCode;
}
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *answerArr;

@end

@implementation MYAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = @"我的问答";

    [self questionHttpRequest];
    //[self ClassHttpRequest];
    
    [self setUpTableFrame];
    
    [self.tableView addHeaderWithTarget:self action:@selector(questionHttpRequest)];
    
}

- (void)setUpTableFrame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MYAnwserTableCell" bundle:nil] forCellReuseIdentifier:@"MYAnwserTableCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 5;
    return self.answerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYAnwserTableCell";
    FirstTableViewCellModal *anwser = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (self.answerArr.count > 0) {
        //MYAnwser *myAnser = [MYAnwser new];
        MYAnwser *myAnser = self.answerArr[indexPath.row];
        [anwser setTableViewCellModel:myAnser];
    }
    return anwser;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MYAnwser *answer = self.answerArr[indexPath.row];
    
    QuestionAndAnswerCon *question = [[QuestionAndAnswerCon alloc] initWithQuestionID:answer.anwserID];
    [self.navigationController pushViewController:question animated:YES];
}

- (void)questionHttpRequest
{
    [self getDataFilePath];
    NSString *questionURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmytw&pagesize=900&pageindex=1&usercode=%@",_userCode];
//    NSLog(@"%@",questionURL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:questionURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无数据"];
            return;
        }
        
        self.answerArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            MYAnwser *answer = [[MYAnwser alloc] init];
            answer.question = dic[@"TW"];
            answer.time = dic[@"CJSJ"];
            answer.anwserNum = dic[@"sumcount"];
            answer.anwserID  = [dic[@"ID"] stringValue];
            [self.answerArr addObject:answer];
        }
        [self.tableView reloadData];
        
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
