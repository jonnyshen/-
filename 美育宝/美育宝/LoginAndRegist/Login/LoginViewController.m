//
//  LoginViewController.m
//  Page Demo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LoginViewController.h"
#import "FormValidator.h"
#import "AFNetworking.h"
#import "RegisterViewController.h"
#import "LoginState.h"
#import "FindPassWordController.h"
#import "LYThreeViewController.h"

#define kLoginUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=loginreq&uname=zw&upwd=90816DF2F42985A4"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
//- (IBAction)clickLoginButton:(id)sender;

@property (nonatomic, strong) NSString *userCode;
@property (nonatomic, strong) NSString *secretPass;
@property (nonatomic, strong) NSString *relationCode;
@property (nonatomic, strong) NSString *classNumber;
@property (nonatomic, strong) NSString *accounttype;
@property (nonatomic, strong) NSString *loginUserName;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *studentNj;




@property (nonatomic, strong) NSUserDefaults *userDefault;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userName.delegate = self;
    self.passWord.delegate = self;
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRegisterBtn)];
    button.tintColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    self.navigationItem.rightBarButtonItem = button;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
}

- (void)clickRegisterBtn
{
    RegisterViewController *registerBtn = [[RegisterViewController alloc]init];
    registerBtn = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:registerBtn animated:YES];
}

- (void)clickBackBtn
{
//    LYThreeViewController *threeCon = [[LYThreeViewController alloc] init];
//    
//    [self.navigationController pushViewController:threeCon animated:YES];
//    exit(0);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIImageView *userLeftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.png"]];
//    userLeftV.contentMode = UIViewContentModeCenter;
//    userLeftV.frame = CGRectMake(15, 0, 10, 20);
    self.userName.leftViewMode = UITextFieldViewModeAlways;
//    self.userName.leftView = userLeftV;
    
//    UIImageView *passLeftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_lock.png"]];
//    passLeftV.contentMode = UIViewContentModeCenter;
//    userLeftV.frame = CGRectMake(14, 0, 10, 20);
    self.passWord.leftViewMode = UITextFieldViewModeAlways;
//    self.passWord.leftView = passLeftV;
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}



- (IBAction)sinaWeiBoLogin:(id)sender {
}

- (IBAction)weChatLogin:(id)sender {
}
- (IBAction)qqLogin:(id)sender {
}
- (IBAction)gotoRegisterVC:(id)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterNav"];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    return fileName;
}

- (void)saveFromPlist
{
    NSString *pathStr = [self getDataFilePath];
    if (!pathStr) {
        
        return;
    }
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject:self.userName.text];
    [data addObject:self.secretPass];
    [data addObject:self.userCode];
    [data addObject:self.relationCode];
    [data addObject:self.classNumber];
    [data addObject:self.accounttype];
    [data addObject:self.loginUserName];
    [data addObject:self.imageString];
    
    [data addObject:self.studentNj];
    
    [data writeToFile:pathStr atomically:YES];
//    NSLog(@"------------------%@",pathStr);
}


//登录方法

- (IBAction)loginAccountButton:(id)sender
{
    NSString *user = [FormValidator checkMobile:self.userName.text];
    NSString *pass = [FormValidator checkPassword:self.passWord.text];
    
    if ([self.userName.text isEqualToString:@""]||self.userName.text == nil || [self.passWord.text isEqualToString:@""] || self.passWord.text == nil) {
        [FormValidator showAlertWithStr:@"用户名或密码不能为空！"];
        return;
    } else {
        if (user) {
            //[FormValidator showAlertWithStr:user];
            //return;
        }
        if (pass) {
            [FormValidator showAlertWithStr:pass];
            return;
        }
    }
    [self loginGoGo];
    
    
}
- (void)loginGoGo
{
    [self.view endEditing:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    
    NSString *url2 = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=encrypt&str=%@", self.passWord.text];
    [manager GET:url2 parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.secretPass = [responseObject objectForKey:@"date"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    [self login];
    
    
}

- (void)login{
    
    if (!self.secretPass) {
        return;
    }
    NSString *loginUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=loginreq&uname=%@&upwd=%@",self.userName.text, self.secretPass];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dicResp = [NSDictionary dictionary];
        dicResp = responseObject;
        if ([[dicResp objectForKey:@"issuccess"] isEqualToString:@"true"]) {
            [FormValidator showAlertWithStr:@"登录成功！"];
   
            NSString *photoStr = responseObject[@"imgurl"];
            NSString *personImage = nil;
            
            for (NSDictionary *dic in responseObject[@"date"]) {
                NSString *userCode = [dic objectForKey:@"UserCode"];
                NSString *relationCode = [dic objectForKey:@"RelationCode"];
                self.userCode = userCode;
                self.relationCode = relationCode;
                self.accounttype  = [dic objectForKey:@"AccountType"];
                self.loginUserName= [dic objectForKey:@"UserName"];
                personImage       = responseObject[@"PersonImage"];
                
            }
            
            if (personImage.length < 6) {
                self.imageString = @"http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4f263b0fc3adbb6fd52663334.jpg";
            } else {
                self.imageString = [NSString stringWithFormat:@"%@%@/%@",photoStr,[personImage substringWithRange:NSMakeRange(0, 6)], personImage];
            }
            
            
//            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.accounttype, @"AccountType", nil];
//            NSNotification *notice = [NSNotification alloc] initWithName:@"" object:<#(nullable id)#> userInfo:<#(nullable NSDictionary *)#>
            
            self.classNumber = dicResp[@"stuBj"];
            self.studentNj    = [dicResp objectForKey:@"ssNj"];
            [self saveFromPlist];
            
            
            
            [LoginState setLogined];
            [self popBack];
        } else {
            
            [FormValidator showAlertWithStr:@"用户名或密码不正确"];
            return;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"登录失败！"];
    }];
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"%@",self.userDefault);
}

- (void)getUserDefault:(NSUserDefaults *)userDefault
{
    userDefault = self.userDefault;
}


- (void)popBack{
    if (self.loginType == LoginType_Normal) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.loginType == LoginType_Parent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
        //        [self.tabBarController setSelectedIndex:3];
    }
}

+ (void)login:(UIViewController *)ctrl loginType:(LoginType)loginType{
    if ([LoginState isLogin]) { // 已经登录了
        return;
    }
    else{ // 没有登录
        LoginViewController *LVC = [[LoginViewController alloc] init];
        LVC.loginType = loginType;
        
        LVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        if (loginType == LoginType_Normal) {
            [ctrl.navigationController pushViewController:LVC animated:YES];
        }
        else if (loginType == LoginType_Parent){
            [ctrl presentViewController:LVC animated:YES completion:nil];
        }
        else{
            [ctrl.navigationController pushViewController:LVC animated:YES];
        }
    }
}


- (IBAction)forgetterPassWord:(id)sender
{
    FindPassWordController *findPwd = [[FindPassWordController alloc] init];
    [self.navigationController pushViewController:findPwd animated:YES];
    
    
    
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
