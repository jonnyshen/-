//
//  MYNotesController.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYNotesController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "FirstTableViewCellModal.h"
#import "MYNotes.h"
#import "MYToolsModel.h"
#import "LYPlayerViewController.h"
#import "MYNotesTableCell.h"
#import "FormValidator.h"

@interface MYNotesController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_userCode;
    NSString *_passWord;
}
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *notesArr;

@end

@implementation MYNotesController

- (NSMutableArray *)notesArr
{
    if (!_notesArr) {
        _notesArr = [[NSMutableArray alloc] init];
    }
    return _notesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的笔记";
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    [self notesHttpRequest];
    
    [self setUpTableFrame];
    
    [self.tableView addHeaderWithTarget:self action:@selector(notesHttpRequest)];

}

- (void)setUpTableFrame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"MYNotesTableCell" bundle:nil] forCellReuseIdentifier:@"MYNotesTableCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 5;
    return self.notesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYNotesTableCell";
    

    MYNotesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell.deleButton addTarget:self action:@selector(deleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.notesArr.count > 0) {
      
        MYNotes *notes = self.notesArr[indexPath.row];
        cell.obj = notes;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MYNotes *notes = self.notesArr[indexPath.row];
    NSString *videoUrl = [self pieceStringTogether:notes.videoStr];
    
    LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoURL:videoUrl andComeFromWhichVC:@"VIDEOURL"];
    player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
    [self presentViewController:player animated:YES completion:nil];
}

- (NSString *)pieceStringTogether:(NSString *)originalStr
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"Notes.plist" andNumber:0];
    
    NSString *cutIndexStr = [originalStr substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, originalStr];
    
    return imageUrl;
}

- (void)notesHttpRequest
{
    [self getDataFilePath];
    NSString *notesUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyxxbj&pagesize=5&pageindex=1&usercode=%@",_userCode];
    
    NSInteger pagesize = [self requestForAcountSum:notesUrl];
    
    NSString *NOTES_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyxxbj&pagesize=%ld&pageindex=1&usercode=%@",pagesize, _userCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:NOTES_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"%@",notesUrl);
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *source = [responseObject objectForKey:@"filespath"];
        [tools saveToPlistWithPlistName:@"Notes.plist" andData:source];
        
        [self.notesArr removeAllObjects];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            MYNotes *notes = [[MYNotes alloc] init];
            if ([dic[@"KSMC"] isKindOfClass:[NSNull class]]) {
                
            } else {
                notes.className = dic[@"KSMC"];
            }
        
            notes.classId   = dic[@"ID"];
            notes.classIdentifer = dic[@"KSH"];
            notes.times     = dic[@"CJSJ"];
            notes.notes     = dic[@"BJMS"];
            notes.videoStr  = dic[@"SPWJ"];

            [self.notesArr addObject:notes];
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
        _passWord = [path objectAtIndex:1];
    }
}

- (NSInteger)requestForAcountSum:(NSString *)urlString
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
   
    __block NSInteger pageSize = 10;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        pageSize = [[dict objectForKey:@"sumcount"] integerValue];
        
    }];
    [dataTask resume];
    return pageSize;
}


- (void)deleButtonClick:(UIButton *)btn
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"删除笔记" message:@"亲，删除之后将再也看不到了哦！" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *concertBtn = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell *)[[btn superview] superview]];
        [self clickDeleteButtonAction:index.row];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:concertBtn];
    [alertControl addAction:cancelBtn];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)clickDeleteButtonAction:(NSInteger)index
{

    MYNotes *notes = self.notesArr[index];
    NSString *deleUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=delbj&ucode=%@&upwd=%@&id=%@",_userCode, _passWord,notes.classId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:deleUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            [self notesHttpRequest];
            
            [FormValidator showAlertWithStr:@"已删除！"];
        } else {
            [FormValidator showAlertWithStr:@"删除失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
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
