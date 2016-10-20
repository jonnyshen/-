//
//  LYAddViewController.m
//  Page Demo
//
//  Created by apple on 16/5/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYAddViewController.h"
#import "MXPhotoView.h"
#import "AFNetworking.h"
#import "FormValidator.h"
#import "MYToolsModel.h"
#import "GTMBase64.h"


#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define SPACES 10
#define COLORRGB(a,b,c)  [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define kSAVEDAOXUEURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=savezpinfo&ucode=&dxid=&zbh=&zpmc=&xqid="

#define WEB_ADDRESS @"http://192.168.1.254/"
#define WEB_Service @"FileUp.asmx"
#define WEB_Function_Name @"CreateFile"
#define WEB_NameSpace @"http://tempuri.org/CreateFile"
#define WEB_Service_Url @"http://192.168.3.254:8082/FileUp.asmx"

@interface LYAddViewController ()<MXPhotoViewUpdateDelegate,NSURLSessionDelegate,MXPhotoViewUpdateDelegate>

{
    NSString *_userCode;
    
    NSString *_period;
    NSString *class_Number;
    NSString *_materail;
    NSString *_periodID;
}
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UITextView *YQtextView;
@property (assign, nonatomic) BOOL postSuccess;

@property (nonatomic, strong) NSString *titleLb;

@property (strong, nonatomic) MXPhotoView *mxPhotoView;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) UIActivityIndicatorView *activeView;
@end

@implementation LYAddViewController


- (instancetype)initWithTargetPeriodName:(NSString *)period withSender:(NSString *)classNumber materialCode:(NSString *)material periodID:(NSString *)periodid
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _period      = period;
    class_Number = classNumber;
    _materail    = material;
    _periodID    = periodid;
    self.titleLb   = period;
    return self;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.title = @"新增导学";
    self.postSuccess = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mxPhotoView = [[MXPhotoView alloc] init];
    self.mxPhotoView.photoViewDele = self;
    self.mxPhotoView.delegate = self;
    self.mxPhotoView.isNeedMovie = YES;
    self.mxPhotoView.showNum = 4;
    [self.photoView addSubview:self.mxPhotoView];
    
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addNewDaoXue)];
    
        [self.navigationItem setRightBarButtonItem:addBtn];
    

    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *fuck = [tools sendFileString:@"Fuck.plist" andNumber:0];
    self.titleLabel.text = [NSString stringWithFormat:@"%@课前导学",fuck];
// UIActivityIndicatorView 菊花
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.activeView = activeView;
    [activeView setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [activeView setCenter:CGPointMake(self.view.frame.origin.x/2, self.view.frame.origin.y/2)];
    
    [self.view addSubview:activeView];
    
}

- (void)addNewDaoXue {
    
//    [self.titleLabel clearsOnBeginEditing];
    //获取系统时间戳
 
}

- (void)imageName:(NSString *)name
{
    
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    
    NSString *appendingStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AppendToFile xmlns=\"http://tempuri.org/\"><fileName>%@</fileName><buffer>%@</buffer><type>%@</type></AppendToFile></soap:Body></soap:Envelope>",name,self.imageArray.firstObject,@"2"];
//        NSLog(@"------->%@",appendingStr);
    
    NSString *appending_File_Length = [NSString stringWithFormat:@"%ld",appendingStr.length];
    
    
    NSMutableURLRequest *appendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file_Name_Url]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [appendRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"content-type"];
    [appendRequest addValue:appending_File_Length forHTTPHeaderField:@"content-length"];
    [appendRequest addValue:@"http://tempuri.org/AppendToFile" forHTTPHeaderField:@"SOAPAction"];
    [appendRequest setHTTPMethod:@"POST"];

    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionUploadTask *appendDataTask = [manager uploadTaskWithRequest:appendRequest fromData:[appendingStr dataUsingEncoding:NSUTF8StringEncoding] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
        if (error)
            NSLog(@"Error: %@", error);
        else
            NSLog(@"%@",response);
        

        NSLog(@"----->%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    }];
    [appendDataTask resume];
    
    if (appendDataTask) {
        NSLog(@"success----------");
        
    }

}

//选择图片
- (void)upLoadImageWithData:(NSData *)data
{
    
    NSString *abc = [data base64EncodedStringWithOptions:0];
    
    [self.imageArray addObject:abc];
    
}
//选择视频
- (void)upLoadVideoWithData:(NSData *)data
{
    
}

//保存导学
- (IBAction)saveDaoXue:(id)sender
{
    if (self.YQtextView.text == nil ||[self.YQtextView.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"您尚未输入任何内容"];
        return;
    }
    
    [self.activeView startAnimating];
    
    //获取系统时间戳
    NSDate *dateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    NSString *imageName = [[NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:dateTime]] substringFromIndex:2];
    
    [self createFieldName:imageName];
    
 
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
//    NSString *userPass = [tools sendFileString:@"LoginData.plist" andNumber:1];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savedxzp&bjbh=%@&xscode=%@&relationcode=%@&dxid=%@&zbh=%@&zpmc=%@&wjmc=%@&wjlx=.png&wjdx=1024",class_Number,userCode,relationCode,_periodID,_materail,self.YQtextView.text,imageName];

        
        NSString *codeUrl = [saveUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       
        [manager POST:codeUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存成功"];
            } else {
                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存失败"];
            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
    });
    
}

- (void)createFieldName:(NSString *)timeString
{
   MYToolsModel *tools = [[MYToolsModel alloc] init];
    
    NSString *userPass = [tools sendFileString:@"LoginData.plist" andNumber:1];
    NSString *userName = [tools sendFileString:@"LoginData.plist" andNumber:6];
    
    NSString *create_File_Name = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><CreateFile xmlns=\"http://tempuri.org/\"><uName>%@</uName><uPwd>%@</uPwd><fileName>%@</fileName><type>%@</type></CreateFile></soap:Body></soap:Envelope>",userName, userPass,timeString, @"2"];
    //    NSLog(@"%@",create_File_Name);
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    NSString *file_Name_Length = [NSString stringWithFormat:@"%ld",create_File_Name.length];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file_Name_Url]];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"content-type"];
    [request addValue:@"http://tempuri.org/CreateFile" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:file_Name_Length forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[create_File_Name dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"======>>%@",datastr);
        [self imageName:timeString];
    }];
    
    [dataTask resume];
}

- (IBAction)pushMessage:(id)sender {
    
    if (self.YQtextView.text == nil ||[self.YQtextView.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"您尚未输入任何内容"];
        return;
    }
    
    NSDictionary *pushDic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.text, @"BTtext", self.YQtextView.text, @"YQtextView", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kSAVEDAOXUEURL parameters:pushDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.postSuccess = YES;
        [FormValidator showAlertWithStr:@"推送成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        self.postSuccess = NO;
        [FormValidator showAlertWithStr:@"推送失败"];
        
    }];
    
}

- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    //NSString *fileNamePlayer = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    
    NSString *user = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        user = [path objectAtIndex:2];
       
    }
    
    return user;
    
}


@end
