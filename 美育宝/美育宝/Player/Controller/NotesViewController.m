//
//  NotesViewController.m
//  Page Demo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "NotesViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "FormValidator.h"
#import "NotesModel.h"
#import "LoginViewController.h"
#import "LYOneViewController.h"
#import "FirstTableViewCellModal.h"

//#define kNotesUrl @""

#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height

#define kAddViewX kView_H - 20- 200 - 70 - 49 - 50

@interface NotesViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *saveNotesView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (nonatomic, strong) NSMutableArray *notesNum;
@property (nonatomic, strong) NSString *playerID;
@property (nonatomic, strong) NSString *userCode;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSMutableArray *tempArr;
@property (nonatomic, strong) LoginViewController *delegate;

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpFirstUI];
    
    [self httpRequest];
    
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addHeaderWithTarget:self action:@selector(httpRequest)];
    
    [self.saveBtn addTarget:self action:@selector(clickSaveNotesBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void) setUpFirstUI {
    
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, kView_W, kAddViewX);
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MYPlayerNotesTableCell" bundle:nil] forCellReuseIdentifier:@"MYPlayerNotesTableCell"];
    
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, kAddViewX, kView_W, 50)];
    self.addView = addView;
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(addView);
        make.size.mas_equalTo(CGSizeMake(kView_W / 4, 50));
    }];
    [button addTarget:self action:@selector(clickAddNotesBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"append_btn.png"]];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(button);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
}

- (void)clickAddNotesBtn
{
    self.tableView.hidden = YES;
    self.addView.hidden = YES;
    self.saveNotesView.hidden = NO;
    
}
- (void)clickSaveNotesBtn
{
    self.saveNotesView.hidden = YES;
    self.tableView.hidden = NO;
    self.addView.hidden = NO;
    
    [self saveNotesRequest];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYPlayerNotesTableCell";
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    if (self.tempArr.count > 0) {
        NotesModel *notes = self.tempArr[indexPath.row];
        [cell setTableViewCellModel:notes];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//获取笔记数据
- (void)httpRequest
{
    [self getDataFilePath];
    //http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcxxbj&ucode=R000000003&upwd=90816DF2F42985A4&kcid=8787AE95-1127-404E-8F79-44048F8EEDE5&ksh=
    NSString *kNotesUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcxxbj&ucode=%@&upwd=%@&kcid=%@&ksh=",self.userCode, self.pwd,self.playerID];
//    NSLog(@"------------------------%@",kNotesUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kNotesUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"-------------------------------------%@",responseObject);
        if (![responseObject[@"XXBJ"] isKindOfClass:[NSArray class]]) {
            return;
        }
        
        self.tempArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"XXBJ"]) {
            NotesModel *notes = [[NotesModel alloc] init];
            notes.date = dic[@"CJSJ"];
            notes.notes = dic[@"BJMS"];
            [self.tempArr addObject:notes];
        }
        //NSLog(@"---savenote--%@",self.tempArr);
        [self.tableView reloadData];
       
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}




#pragma mark - 保存笔记
- (void)saveNotesRequest
{
    //http://192.168.3.254:8082/GetDataToApp.aspx?action=savexbkcbj&ucode=R000000003&upwd=90816DF2F42985A4&kcid=8787AE95-1127-404E-8F79-44048F8EEDE5&ksh=27&bjnr=为什么会是这样的呢？
    if (self.notesTextView == nil) {
        [FormValidator showAlertWithStr:@"请输入笔记内容"];
        return;
    }
    [self getDataFilePath];
    NSString *saveNotesUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savexbkcbj&ucode=%@&upwd=%@&kcid=%@&ksh=27&bjnr=%@",self.userCode, self.pwd, self.playerID, self.notesTextView.text];
    NSString *testUrl = [saveNotesUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:testUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([[responseObject objectForKey:@"issuccess"] isEqualToString:@"true"]) {
            
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            [FormValidator showAlertWithStr:@"保存成功"];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"保存失败"];
    }];
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NotesModel *notes = [[NotesModel alloc] init];
    notes.notes = self.notesTextView.text;
    notes.date = locationString;
    [self.tempArr addObject:notes];
    [self.tableView reloadData];
    
}

- (void)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    NSString *fileNamePlayer = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        self.userCode = [path objectAtIndex:2];
        self.pwd = [path objectAtIndex:1];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileNamePlayer]) {
        NSArray *PlayerPath = [[NSArray alloc] initWithContentsOfFile:fileNamePlayer];
        self.playerID = [PlayerPath objectAtIndex:0];
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.notesTextView resignFirstResponder];
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
