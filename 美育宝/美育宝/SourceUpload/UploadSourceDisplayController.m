//
//  UploadSourceDisplayController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "UploadSourceDisplayController.h"
#import "SourceController.h"
#import "MYToolsModel.h"
#import "AFNetworking.h"
#import "FormValidator.h"
#import "ClassifiedCatalogueController.h"

@interface UploadSourceDisplayController ()<NSURLSessionDelegate>
{
    UIImage *_headerImage;
    NSData *_imageData;
    NSString *_imageDataString;
    NSString *imageName;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation UploadSourceDisplayController

- (instancetype)initWithImage:(UIImage *)image andImageData:(NSData *)imageData
{
    self = [super init];
    if (self) {
        _headerImage = image;
        _imageData   = imageData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资源上传";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.headerImageView.image = _headerImage;
    
    _imageDataString = [_imageData base64EncodedStringWithOptions:0];
    
    [self.uploadBtn addTarget:self action:@selector(setUploadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取系统时间戳
    NSDate *dateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    imageName = [[NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:dateTime]] substringFromIndex:2];
    self.titleLabel.text = imageName;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
}

- (void)clickBackBtn
{
//    SourceController *source = [[SourceController alloc] init];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    NSArray *array = self.navigationController.viewControllers;
//    
//    for (UIViewController *controller in array) {
//        if ([controller isKindOfClass:[SourceController class]]) {
//            SourceController *source = (SourceController *)controller;
//            [self.navigationController popToViewController:source animated:YES];
//        }
//    }
    
    
//    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
    
}


- (void)setUploadBtnAction:(UIButton *)uploadBtn
{
    if (self.detailTextField.text == nil ||[self.detailTextField.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"您尚未输入任何内容"];
        return;
    }
    
    UIAlertController *alertConroller = [UIAlertController alertControllerWithTitle:@"选择上传方式" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *temporaryUploadAction = [UIAlertAction actionWithTitle:@"上传临时空间" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *detailMessageAction = [UIAlertAction actionWithTitle:@"选定目录上传" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        ClassifiedCatalogueController *catalogue = [[ClassifiedCatalogueController alloc] init];
        [self.navigationController pushViewController:catalogue animated:YES];
    }];
    
    [alertConroller addAction:temporaryUploadAction];
    [alertConroller addAction:detailMessageAction];
    [alertConroller addAction:cancelAction];
    [self presentViewController:alertConroller animated:YES completion:nil];
    
}

//上传临时空间
- (void)uploadTemporarySpace
{
    [self uploadMessage];
    
//
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    
    NSString *imgData_Length = [NSString stringWithFormat:@"%ld",_imageDataString.length];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savezy&usercode=%@&jyjd=&kch=&nj=&zbh=&zymc=%@&filename=%@&filesize=%@&zyms=&zybh=",userCode,imageName,imageName,imgData_Length];
        
        
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:saveUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                //                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存成功"];
            } else {
                //                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存失败"];
            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
    });

}

//选定目录上传
- (void)chooseClassifiedcCatalogue
{
    
}

- (void)uploadMessage
{
    [self createFieldName:imageName];
    
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    //    NSString *userPass = [tools sendFileString:@"LoginData.plist" andNumber:1];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        /*
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savedxzp&bjbh=%@&xscode=%@&relationcode=%@&dxid=%@&zbh=%@&zpmc=%@&wjmc=%@&wjlx=.png&wjdx=1024",class_Number,userCode,relationCode,_periodID,_materail,self.detailTextField.text,imageName];
        
        
        NSString *codeUrl = [saveUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:codeUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                //                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存成功"];
            } else {
                //                [self.activeView stopAnimating];
                [FormValidator showAlertWithStr:@"保存失败"];
            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        */
        
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

- (void)imageName:(NSString *)name
{
    
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    
    NSString *appendingStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AppendToFile xmlns=\"http://tempuri.org/\"><fileName>%@</fileName><buffer>%@</buffer><type>%@</type></AppendToFile></soap:Body></soap:Envelope>",name,_imageData,@"2"];
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
