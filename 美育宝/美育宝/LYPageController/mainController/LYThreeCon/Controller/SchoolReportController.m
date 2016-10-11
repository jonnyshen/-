//
//  SchoolReportController.m
//  Page Demo
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SchoolReportController.h"
#import "FirstTableViewCellModal.h"
#import "SchoolReortTableCell.h"
#import "TeacherJudgeTableCell.h"
#import "JudgeDetailTableCell.h"
#import "MarksDetailTableCell.h"
#import "SchoolHeaderTableCell.h"

#import "MYTerms.h"
#import "MYSubjectScore.h"
#import "ScoreModel.h"
#import "MYRewardNumber.h"
#import "MYJudge.h"

#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "FormValidator.h"

#define HeaderViewHeight 64
#define ScrollViewHeight 150
#define ViewHeight self.view.frame.size.height
#define ViewWidth self.view.frame.size.width

#define SchoolTerm @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxq"


@interface SchoolReportController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource>
{
    BOOL sectionOneNull;//记录是否有分数数据
}

@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *marksArr;
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSMutableArray *rewardArr;
@property (nonatomic, strong) NSMutableArray *rewardDetailArr;
@property (nonatomic, strong) NSMutableArray *judgeArr;;

@end

@implementation SchoolReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"学期成绩报告";
    //
//    [self headerNavigationItem];
    //
    [self getSchoolRecordHttpRequestWithCode:nil];
    //
    [self setUpTableView];
    //
    [self registerTableViewCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"HeaderCode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationNextCode:) name:@"HeaderNextCode" object:nil];
    
    //[self.tableView addHeaderWithTarget:self action:@selector(getSchoolRecordHttpRequestWithCode:)];
}


//收到通知后执行的方法
- (void)notification:(NSNotification *)notice
{
//    NSLog(@"%@",notice.userInfo[@"termsCode"]);
    NSInteger a = [notice.userInfo[@"termsCode"] integerValue];
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSArray *codeArr = [tools getDataArrayFromPlist:@"TermsCode.plist"];
    
    [self getSchoolRecordHttpRequestWithCode:codeArr[a]];
}

- (void)notificationNextCode:(NSNotification *)notification
{
    NSInteger a = [notification.userInfo[@"nextCode"] integerValue];
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSArray *codeArr = [tools getDataArrayFromPlist:@"TermsCode.plist"];
    
    [self getSchoolRecordHttpRequestWithCode:codeArr[a]];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)headerNavigationItem
{
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, HeaderViewHeight)];
    blueView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blueView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(blueView.frame.size.width/2 - 60, 20, 120, 44)];
    label.text = @"学期成绩报告";
    label.font = [UIFont systemFontOfSize:20.0f];
    label.textColor = [UIColor whiteColor];
    [blueView addSubview:label];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 44)];
    [blueView addSubview:backButton];
//    backButton.backgroundColor = [UIColor redColor];
    [backButton setImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





//设置tableview
- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)registerTableViewCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SchoolHeaderTableCell" bundle:nil] forCellReuseIdentifier:@"SchoolHeaderTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MarksDetailTableCell" bundle:nil] forCellReuseIdentifier:@"MarksDetailTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SchoolReortTableCell" bundle:nil] forCellReuseIdentifier:@"SchoolReortTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherJudgeTableCell" bundle:nil] forCellReuseIdentifier:@"TeacherJudgeTableCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JudgeDetailTableCell" bundle:nil] forCellReuseIdentifier:@"JudgeDetailTableCell"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (sectionOneNull == NO) {
        return 5;
    }else {
    return 3;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sectionOneNull == NO) {
        if (section == 1) {
//            NSLog(@"----------->>%ld",self.scoreArr.count);
            return self.scoreArr.count;
        } else if (section == 3) {
//            NSLog(@"==============%ld",self.rewardDetailArr.count);

            return self.rewardDetailArr.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    
    
    if (sectionOneNull == NO) {
        if (indexPath.section == 0) {
            cellID = @"SchoolHeaderTableCell";
            
        } else if (indexPath.section == 1){
            cellID = @"MarksDetailTableCell";
            
        } else if (indexPath.section == 2) {
            cellID = @"SchoolReortTableCell";
           
        } else if (indexPath.section == 3) {
             cellID = @"TeacherJudgeTableCell";
            
        } else {
            cellID = @"JudgeDetailTableCell";
        }
        
        
        
        
        
        
    } else {
        if (indexPath.section == 0){
             cellID = @"SchoolHeaderTableCell";
            
        } else if (indexPath.section == 1) {
            cellID = @"SchoolReortTableCell";
            
        } else {
            cellID = @"JudgeDetailTableCell";
            
        }
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.userInteractionEnabled = NO;
    
    if (sectionOneNull) {
        if (indexPath.section == 0) {
            SchoolHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolHeaderTableCell" forIndexPath:indexPath];
            [cell setHeaderTableCellModel:cellID];
            //return cell;

        } else if (indexPath.section == 1) {
            ///SchoolReortTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            ScoreModel *score = [ScoreModel new];
            [cell setTableViewCellModel:score];
            return cell;
        } else {
            //JudgeDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            MYJudge *judge = [MYJudge new];
            [cell setTableViewCellModel:judge];
            //return cell;
        }
        
    } else {
        if (indexPath.section == 0) {
            SchoolHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolHeaderTableCell" forIndexPath:indexPath];
            [cell setHeaderTableCellModel:cellID];
            //return cell;
        } else if (indexPath.section == 1) {
            if (self.scoreArr.count > 0) {
                //MarksDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                MYSubjectScore *score = self.scoreArr[indexPath.row];
                //MYSubjectScore *score = [MYSubjectScore new];
                [cell setTableViewCellModel:score];
                //return cell;
            }
        } else if (indexPath.section == 2) {
            if (self.rewardArr.count > 0) {
                //SchoolReortTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                ScoreModel *scoreModel = self.rewardArr[indexPath.row];
                //ScoreModel *scoreModel = [ScoreModel new];
                [cell setTableViewCellModel:scoreModel];
                //return cell;
            }
        } else if (indexPath.section == 3) {
            if (self.rewardDetailArr.count > 0) {
                //TeacherJudgeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                MYRewardNumber *number = self.rewardDetailArr[indexPath.row];
               // MYRewardNumber *number = [MYRewardNumber new];
                [cell setTableViewCellModel:number];
                //return cell;
            }
        } else {
            if (self.judgeArr.count > 0) {
                //JudgeDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
                MYJudge *judge = self.judgeArr[indexPath.row];
                //MYJudge *judge = [MYJudge new];
                [cell setTableViewCellModel:judge];
                //return cell;
            }
        }
    }
    
   
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (sectionOneNull == YES) {
        if (indexPath.section == 0) {
            return 120;
        } else if (indexPath.section == 1 || indexPath.section == 2) {
            return 150;
        } else {
            return 150;
        }
    } else {
        if (indexPath.section == 0) {
            return 120;
        } else if (indexPath.section == 1) {
            return UITableViewAutomaticDimension;
        } else if (indexPath.section == 2) {
            return 150;
        } else if(indexPath.section == 3){
            return 100;
        } else{
            return 150;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && section == 1 && section == 4) {
        return 0;
    }
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - HTTP

- (void)getSchoolRecordHttpRequestWithCode:(NSString *)code
{

         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         MYToolsModel *tools = [[MYToolsModel alloc] init];
             
             NSArray *codeArr = [tools getDataArrayFromPlist:@"TermsCode.plist"];
             if (code == nil) {
                 code = codeArr.firstObject;
                 
             }
        
        
       NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
        NSString *classNumber = [tools sendFileString:@"LoginData.plist" andNumber:4];
        NSString *recordUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxqbg&relationcode=%@&xqm=%@&bjbh=%@",relationCode,code,classNumber];
        
             NSLog(@"%@",recordUrl);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [manager GET:recordUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            if (self.dataDic) {
                [self.scoreArr removeAllObjects];
                [self.rewardArr removeAllObjects];
                [self.rewardDetailArr removeAllObjects];
                [self.judgeArr removeAllObjects];
            }
            
            if ([responseObject[@"datacj"] isKindOfClass:[NSString class]]) {
                sectionOneNull = YES;
                [FormValidator showAlertWithStr:@"该学期暂无数据"];
            } else {
                sectionOneNull = NO;
                for (NSDictionary *dict in responseObject[@"datacj"]) {
                    MYSubjectScore *subject = [[MYSubjectScore alloc] init];
                    subject.subjectName = dict[@"km"];
                    subject.fullScore   = dict[@"mf"];
                    subject.getScore    = dict[@"cj"];
                    subject.teacher     = [dict[@"avg"] stringValue];
                    subject.rank        = [dict[@"PM"] stringValue];
                    [self.scoreArr addObject:subject];
                }
                
                for (NSDictionary *params in responseObject[@"dataxhh"]) {
                    MYRewardNumber *number = [[MYRewardNumber alloc] init];
                    number.rewardTime      = params[@"CJSJ"];
                    if ([params[@"Memo"] isKindOfClass:[NSNull class]]) {
                        
                    } else {
                         number.rewardReason    = params[@"Memo"];
                    }
                   
                    number.teacher         = params[@"UserName"];
                    number.redFlower       = [params[@"XHHS"] stringValue];
                    [self.rewardDetailArr addObject:number];
                }
                ScoreModel *scoreModel = [[ScoreModel alloc] init];
                scoreModel.allScore    = [responseObject[@"summf"] stringValue];
                scoreModel.getScore    = [responseObject[@"sumcj"] stringValue];
                scoreModel.rewardNum   = self.rewardDetailArr.count;
                scoreModel.marksChance = responseObject[@"dfl"];
                [self.rewardArr addObject:scoreModel];
                
                MYJudge *judge = [MYJudge new];
                judge.judge    = responseObject[@"py"];
                [self.judgeArr addObject:judge];
            }
            
            [self.tableView reloadData];
//            [self.tableView headerEndRefreshing];
            
            [self.dataDic setValue:self.scoreArr forKey:@"scoreArr"];
            [self.dataDic setValue:self.rewardDetailArr forKey:@"rewardDetail"];
            [self.dataDic setValue:self.rewardArr forKey:@"rewardArr"];
            [self.dataDic setValue:self.judgeArr forKey:@"judge"];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
    });
}



/*
- (void)lastReport:(UIButton *)sender
{
    SchoolHeaderTableCell *cell = [[SchoolHeaderTableCell alloc] init];
    NSLog(@"-----------------");
    if (a == 0) {
        a = 4;
    }
    a--;
    [cell.sv setContentOffset:CGPointMake(cell.sv.bounds.size.width * a, 0) animated:YES];
    
    
    
}

- (void)nextReport:(UIButton *)sender
{
    NSLog(@"-----------------");
    SchoolHeaderTableCell *cell = [[SchoolHeaderTableCell alloc] init];

    a++;
    if (a == 4) {
        a = 0;
    }
    [cell.sv setContentOffset:CGPointMake(cell.sv.bounds.size.width * a, 0) animated:YES];
}
*/


#pragma mark - 懒加载

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}


- (NSMutableArray *)marksArr
{
    if (!_marksArr) {
        _marksArr = [[NSMutableArray alloc] init];
    }
    return _marksArr;
}
- (NSMutableArray *)scoreArr
{
    if (!_scoreArr) {
        _scoreArr = [[NSMutableArray alloc] init];
    }
    return _scoreArr;
}
- (NSMutableArray *)rewardArr
{
    if (!_rewardArr) {
        _rewardArr = [[NSMutableArray alloc] init];
    }
    return _rewardArr;
}
- (NSMutableArray *)rewardDetailArr
{
    if (!_rewardDetailArr) {
        _rewardDetailArr = [[NSMutableArray alloc] init];
    }
    return _rewardDetailArr;
}
- (NSMutableArray *)judgeArr
{
    if (!_judgeArr) {
        _judgeArr = [[NSMutableArray alloc] init];
    }
    return _judgeArr;
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
