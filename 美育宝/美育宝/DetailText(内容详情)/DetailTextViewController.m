//
//  DetailTextViewController.m
//  Page Demo
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DetailTextViewController.h"
#import "PreviewImageView.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "FormValidator.h"

#import "CommListModel.h"
#import "CommentListCell.h"
#import "FirstTableViewCellModal.h"
#import "LoginViewController.h"
#import "LoginState.h"
#import "MYToolsModel.h"
#import "WXApi.h"

static NSString *kLinkURL = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
static NSString *kLinkTitle = @"专访张小龙：产品之上的世界观";
static NSString *kLinkDescription = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";
@interface DetailTextViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_classID;
    NSString *_title;
    NSString *_imageUrl;
    NSString *_userCode;
    NSString *_PassWord;
    
    NSString *_fromVC;
    NSString *_imgString;
    NSString *_commentID;
    NSString *_titleThree;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commArr;
@property (nonatomic, strong) MYToolsModel *toolsModel;
@end

@implementation DetailTextViewController

- (instancetype)initWithImageString:(NSString *)nibNameOrNil commemtID:(NSString *)nibBundle from:(NSString *)controller title:(NSString *)title
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _title = title;
    _commentID = nibBundle;
    _imgString = nibNameOrNil;
    _fromVC = controller;
    return self;
}

- (NSMutableArray *)commArr
{
    if (!_commArr) {
        _commArr = [[NSMutableArray alloc] init];
    }
    return _commArr;
}

- (MYToolsModel *)toolsModel
{
    if (!_toolsModel) {
        _toolsModel = [[MYToolsModel alloc] init];
    }
    return _toolsModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //头部视图
    [self getTitleAndImageDataFromPlist];
    [self setUpHeaderImages];
    //获取评论数据（评论人名字，）
    [self getJudgeHttpRequest];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView headerBeginRefreshing];
    [self.tableView addHeaderWithTarget:self action:@selector(getJudgeHttpRequest)];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonClick)];
    self.navigationItem.rightBarButtonItem = shareBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToWeChatFriends) name:@"WECHATFRIENDS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToWeChatFriendsCircle) name:@"WECHATFRIENDSCIRLE" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shareButtonClick
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *shareToFriendsButton   = [UIAlertAction actionWithTitle:@"分享到微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //创建发送对象实例
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]]]];
        
        WXImageObject *ext = [WXImageObject object];

        ext.imageData  = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        UIImage *image = [UIImage imageWithData:ext.imageData];
        ext.imageData  = UIImagePNGRepresentation(image);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText   = NO;
        req.message = message;
        req.scene   = 0;
        
        [WXApi sendReq:req];
    }];
    UIAlertAction *shareToWeChatButton   = [UIAlertAction actionWithTitle:@"分享到朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        WXMediaMessage *message = [WXMediaMessage message];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        [message setThumbImage:[UIImage imageWithData:imageData]];
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData  = imageData;
        UIImage *image = [UIImage imageWithData:ext.imageData];
        ext.imageData  = UIImagePNGRepresentation(image);
        
        message.mediaObject = ext;
        [WXApi sendReq:sendReq];
        
        
        
        /*
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = kLinkTitle;//分享标题
        urlMessage.description = kLinkDescription;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"babyImage.jpg"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = kLinkURL;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        [WXApi sendReq:sendReq];
         */
    }];
    
   
    
    [alertController addAction:cancelButton];
    
    
    [alertController addAction:shareToFriendsButton];
    [alertController addAction:shareToWeChatButton];
    UIAlertAction *collectToWeChat   = [UIAlertAction actionWithTitle:@"微信收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //创建发送对象实例
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 2;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]]]];
        
        WXImageObject *ext = [WXImageObject object];
        
        ext.imageData  = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
        UIImage *image = [UIImage imageWithData:ext.imageData];
        ext.imageData  = UIImagePNGRepresentation(image);
        
        message.mediaObject = ext;
        [WXApi sendReq:sendReq];
    }];
    [alertController addAction:collectToWeChat];
    [self presentViewController:alertController animated:YES completion:nil];
}

//分享给微信好友
- (void)shareToWeChatFriends
{
    //创建发送对象实例
    WXMediaMessage *message = [WXMediaMessage message];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    [message setThumbImage:[UIImage imageWithData:imageData]];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData  = imageData;
    UIImage *image = [UIImage imageWithData:ext.imageData];
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = 0;
    
    [WXApi sendReq:req];
}
//分享到朋友圈
- (void)shareToWeChatFriendsCircle
{
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    [message setThumbImage:[UIImage imageWithData:imageData]];
    
    WXImageObject *ext = [WXImageObject object];
    
    ext.imageData  = imageData;
    UIImage *image = [UIImage imageWithData:ext.imageData];
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    [WXApi sendReq:sendReq];
}

//头部视图增加手势
-(void)setUpHeaderImages
{
    
//    self.titleLB.text = _title;
//    
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 8.0;
    self.imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    //添加手势，使图片放大到整个屏幕前面
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self.imageView addGestureRecognizer:tapGR];
}

//添加手势，使图片放大到整个屏幕前面
- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [self.imageView convertRect:self.imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:self.imageView.image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
}

//评论确定按钮
- (IBAction)clickCommentButton:(id)sender
{
    if ([LoginState isLogin]) {
        self.commentText.text = nil;
//        确定评论发送网络请求
        [self saveJudgeHttpRequest];
        
        [self.tableView footerEndRefreshing];
    } else {
        //没有登陆调转到登录界面
        [LoginViewController login:self loginType:LoginType_Normal];
    }
    
    
   
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ListCell";
//    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell.deleteBtn addTarget:self action:@selector(deleteCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (self.commArr.count > 0) {
        CommListModel *listModel = self.commArr[indexPath.row];
        cell.obj = listModel;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.commArr) {
        [self.commArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        [self deleteAction:indexPath.row];
    }
    
}



//将评论发送到服务器
- (void)saveJudgeHttpRequest
{
//    http://192.168.3.254:8082/GetDataToApp.aspx?action=savepl&ucode=R000000003&upwd=90816DF2F42985A4&infoid=F642A7DB-0FC4-43D3-9C47-641A458BCA12&pjdj=3&pjnr=不错，值得学习&type=2
    //将评论数据拼接到借口
    NSString *saveJudgeUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savepl&ucode=%@&upwd=%@&infoid=%@&pjdj=3&pjnr=%@&type=1", _userCode, _PassWord, _classID, self.commentText.text];
//    特殊字符串转换方法
    NSString *text = [saveJudgeUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:text parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *success = [responseObject objectForKey:@"issuccess"];
        if ([success isEqualToString:@"true"]) {
            [self getJudgeHttpRequest];
            [FormValidator showAlertWithStr:@"保存成功"];
        }
        [self.tableView reloadData];
        [self.tableView headerBeginRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    

    
    
}

//从服务器获取数据
- (void)getJudgeHttpRequest
{
    NSString *detailUrl = nil;
    
    if ([_fromVC isEqualToString:@"THREE"]) {
        detailUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getpllist&infoid=%@&type=1&pagesize=100&pageindex=1",_commentID];
    } else {
        [self getDataFilePath];
        detailUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getpllist&infoid=%@&type=1&pagesize=100&pageindex=1",_classID];
    }
    
    
//    NSLog(@"----------------%@",detailUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:detailUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *sumcount = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"sumcount"]];
        
        if ([sumcount isEqualToString:[NSString stringWithFormat:@"%d",0]]) {
            return;
        }
        
        self.commArr = [NSMutableArray array];
        [self.commArr removeAllObjects];
        for (NSDictionary *param in responseObject[@"data"]) {
            CommListModel *model = [[CommListModel alloc] init];
            model.imageUrl = param[@"PersonImage"];
            model.teacherName = param[@"UserName"]; // 评论人的名字
            model.comment = param[@"PJMS"];
            model.commentIdentifier = param[@"ID"];
            [self.commArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
    
}

- (void)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    NSString *login = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _classID = [path objectAtIndex:0];
        
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:login]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:login];
        _userCode = [path objectAtIndex:2];
        _PassWord = [path objectAtIndex:1];
    }
    
}

- (void)getTitleAndImageDataFromPlist
{
    if ([_fromVC isEqualToString:@"THREE"]) {
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *imgStr = [tools sendFileString:@"Three.plist" andNumber:0];
        NSString *pieceStr = [_imgString substringWithRange:NSMakeRange(0, 6)];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, pieceStr,_imgString];
        self.titleLB.text = _titleThree;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
    } else if ([_fromVC isEqualToString:@" "]) {
        self.titleLB.text = _title;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imgString]];
    } else {
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [filePath objectAtIndex:0];
        NSString *source = [documentPath stringByAppendingPathComponent:@"TitltAndImage.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:source]) {
            NSArray *path = [[NSArray alloc] initWithContentsOfFile:source];
            _title = [path objectAtIndex:0];
            _imageUrl = [path objectAtIndex:1];
            
            self.titleLB.text = _title;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
            
        }
    }
    
}


//删除评论
- (void)deleteCommentBtn:(UIButton *)btn
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"删除笔记" message:@"亲，删除之后将再也看不到了哦！" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *concertBtn = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell *)[[btn superview] superview]];
        
        [self deleteAction:index.row];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:concertBtn];
    [alertControl addAction:cancelBtn];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

//删除评论操作
- (void)deleteAction:(NSInteger)index
{
    CommListModel *model = self.commArr[index];
    NSString *delete = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=delpl&ucode=%@&upwd=%@&id=%@",_userCode,_PassWord,model.commentIdentifier];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:delete parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
//            [self getJudgeHttpRequest];
            
//            [FormValidator showAlertWithStr:@"已删除！"];
        } else {
            [FormValidator showAlertWithStr:@"删除失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.commentText resignFirstResponder];
//    [self.passWord resignFirstResponder];
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
