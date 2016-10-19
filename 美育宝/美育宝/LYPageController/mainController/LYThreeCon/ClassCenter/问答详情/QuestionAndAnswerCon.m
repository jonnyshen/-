//
//  QuestionAndAnswerCon.m
//  美育宝
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "QuestionAndAnswerCon.h"
#import "messModel.h"
#import "modelFrame.h"
#import "CustomTableViewCell.h"
#import "AFNetworking.h"
#import "MYSunCount.h"
#import "MYToolsModel.h"
#import "FormValidator.h"

#define QUESTION_URL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmytwhd&pagesize=5&pageindex=1&wtid=1"

@interface QuestionAndAnswerCon ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *identifier;
}

@property (weak, nonatomic) IBOutlet UITableView *customTableView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITextField *inputMess;

- (IBAction)sendAction:(UIButton *)sender;

@property (nonatomic,strong)NSMutableArray *arrModelData;


@end

@implementation QuestionAndAnswerCon

- (instancetype)initWithQuestionID:(NSString *)identify
{
    self = [super init];
    if (self) {
       identifier = identify;
    }
    return self;
}

-(NSMutableArray *)arrModelData{
    if (_arrModelData==nil) {
        _arrModelData=[NSMutableArray array];
    }
    return _arrModelData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问答详情";
    
    [self someControllerSet];
    [self setmessModelArr];
    // 监听键盘出现的出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SOME UI SET
- (void)someControllerSet
{
    self.customTableView.delegate   = self;
    self.customTableView.dataSource = self;
    self.inputMess.delegate         = self;//设置UITextField的代理
    self.inputMess.returnKeyType    = UIReturnKeySend;//更改返回键的文字 (或者在sroryBoard中的,选中UITextField,对return key更改)
    self.inputMess.clearButtonMode  = UITextFieldViewModeWhileEditing;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    self.customTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    [self.customTableView setBackgroundView:bgView];
    [self.customTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.customTableView setShowsVerticalScrollIndicator:NO];
    
}


//获取问答数据
- (void)setmessModelArr
{
    
//    MYSunCount *sumcount = [[MYSunCount alloc] init];
//    NSInteger count = [sumcount requestForAcountSum:@"sumcount" requestURL:QUESTION_URL];
    
    NSString *answer_Url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmytwhd&pagesize=1000&pageindex=1&wtid=%@", identifier];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:answer_Url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无问答数据"];
            return;
        }
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"QuestionAndAnswer.plist" andData:responseObject[@"filepath"]];
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            messModel *model=[[messModel alloc]initWithModel:dict]; //将数据转为模型
            
//            NSLog(@"%@---%@---%@---",model.time,model.desc,model.imageName);
            
            
            
            BOOL isEquel;
            if(self.arrModelData){
                isEquel=[self timeIsEqual:model.time];//判断上一个模型数据里面的时间是否和现在的时间相等
            }
            modelFrame *frameModel=[[modelFrame alloc]initWithFrameModel:model timeIsEqual:isEquel];//将模型里面的数据转为Frame,并且判断时间是否相等
            [self.arrModelData addObject:frameModel];//添加Frame的模型到数组里面
        
        }
        [self.customTableView reloadData];
//        NSLog(@"%@",self.arrModelData);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark  -TableView的DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrModelData.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    modelFrame *frameModel=self.arrModelData[indexPath.row];
    return frameModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strId=@"cellId";
    CustomTableViewCell *customCell=[tableView dequeueReusableCellWithIdentifier:strId];
    if (customCell==nil) {
        customCell=[[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    [customCell setBackgroundColor:[UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:221.0/255.0f alpha:1.0f]];
    customCell.selectionStyle=UITableViewCellSelectionStyleNone;
    customCell.frameModel=self.arrModelData[indexPath.row];
    return customCell;
}

#pragma mark 键盘将要出现
-(void)keyboardWillShow:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 键盘消失完毕
-(void)keyboardWillHide:(NSNotification *)notifa{
    [self dealKeyboardFrame:notifa];
}
#pragma mark 处理键盘的位置
-(void)dealKeyboardFrame:(NSNotification *)changeMess{
    NSDictionary *dicMess=changeMess.userInfo;//键盘改变的所有信息
    CGFloat changeTime=[dicMess[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];//通过userInfo 这个字典得到对得到相应的信息//0.25秒后消失键盘
    CGFloat keyboardMoveY=[dicMess[UIKeyboardFrameEndUserInfoKey]CGRectValue].origin.y-[UIScreen mainScreen].bounds.size.height;//键盘Y值的改变(字典里面的键UIKeyboardFrameEndUserInfoKey对应的值-屏幕自己的高度)
    [UIView animateWithDuration:changeTime animations:^{ //0.25秒之后改变tableView和bgView的Y轴
        self.customTableView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
        self.bgView.transform=CGAffineTransformMakeTranslation(0, keyboardMoveY);
        
    }];
    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];//将tableView的行滚到最下面的一行
}
#pragma mark 滚动TableView去除键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.inputMess resignFirstResponder];
}
#pragma mark TextField的Delegate send后的操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{  //
    [self sendMess:textField.text]; //发送信息
    return YES;
}


#pragma mark - 点击发送问答详情

- (IBAction)sendAction:(UIButton *)sender
{
//  发送我的聊天消息数据到服务器。
//    -(void)sendMess:(NSString*)messValues。。。。。。。。。。。。。。。。。。。。。。。。。。
    [self sendMess:self.inputMess.text]; //send message
}

#pragma mark 发送消息,刷新数据
-(void)sendMess:(NSString *)messValues{
    //添加一个数据模型(并且刷新表)
    //获取当前的时间
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *forMatter=[[NSDateFormatter alloc]init];
    forMatter.dateFormat=@"yyyyMMddHHmm"; //小时和分钟
    NSString *nowTime=[forMatter stringFromDate:nowdate];
    
    NSMutableDictionary *dicValues=[NSMutableDictionary dictionary];
    dicValues[@"Person"]=@"girl";
    dicValues[@"TW"]=messValues;
    dicValues[@"CJSJ"]  =nowTime; //当前的时间
    dicValues[@"AccountType"]= @"student"; //转为Bool类型
    messModel *mess=[[messModel alloc]initWithModel:dicValues];
    modelFrame *frameModel=[modelFrame modelFrame:mess timeIsEqual:[self timeIsEqual:nowTime]]; //判断前后时候是否一致
    [self.arrModelData addObject:frameModel];
    [self.customTableView reloadData];
    
    self.inputMess.text=nil;
    
    /*
    //自动回复就是再次添加一个frame模型
    NSArray *arrayAutoData=@[@"蒸桑拿蒸馒头不争名利，弹吉它弹棉花不谈感情",@"女人因为成熟而沧桑，男人因为沧桑而成熟",@"男人善于花言巧语，女人喜欢花前月下",@"笨男人要结婚，笨女人要减肥",@"爱与恨都是寂寞的空气,哭与笑表达同样的意义",@"男人的痛苦从结婚开始，女人的痛苦从认识男人开始",@"女人喜欢的男人越成熟越好，男人喜欢的女孩越单纯越好。",@"做男人无能会使女人寄希望于未来，做女人失败会使男人寄思念于过去",@"我很优秀的，一个优秀的男人，不需要华丽的外表，不需要有渊博的知识，不需要有沉重的钱袋",@"世间纷繁万般无奈，心头只求片刻安宁"];
    //添加自动回复的
    int num= arc4random() %(arrayAutoData.count); //获取数组中的随机数(数组的下标)
    
    
    //    NSLog(@"得到的时间是:%@",nowdate);
    NSMutableDictionary *dicAuto=[NSMutableDictionary dictionary];
    dicAuto[@"imageName"]=@"boy";
    dicAuto[@"desc"]=[arrayAutoData objectAtIndex:num];
    dicAuto[@"time"]=nowTime;
    dicAuto[@"person"]=[NSNumber numberWithBool:1]; //转为Bool类型
    messModel *messAuto=[[messModel alloc]initWithModel:dicAuto];
    modelFrame *frameModelAuto=[modelFrame modelFrame:messAuto timeIsEqual:[self timeIsEqual:nowTime]];//判断前后时候是否一致
    //    [self.arrModelData addObject:frameModelAuto];
    //    [self.customTableView reloadData];
    
    //    NSIndexPath *path=[NSIndexPath indexPathForItem:self.arrModelData.count-1 inSection:0];
    //    [self.customTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
     */
}

#pragma mark 判断前后时间是否一致
-(BOOL)timeIsEqual:(NSString *)comStrTime{
    modelFrame *frame=[self.arrModelData lastObject];
    NSString *strTime=frame.dataModel.time; //frame模型里面的NSString时间
    if ([strTime isEqualToString:comStrTime]) { //比较2个时间是否相等
        return YES;
    }
    return NO;
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
