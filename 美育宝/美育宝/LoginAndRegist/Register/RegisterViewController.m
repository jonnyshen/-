//
//  RegisterViewController.m
//  Page Demo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "RegisterViewController.h"
#import "FormValidator.h"
#import "AFNetworking.h"

#define kRegisterUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=userregister&username=&userpass=&usersfzh=&useremail=&userphone=&usertype=&realname=&sex="

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *confirmPass;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *realNmae;
@property (weak, nonatomic) IBOutlet UITextField *mailAdd;
@property (weak, nonatomic) IBOutlet UITextField *idNum;
@property (weak, nonatomic) IBOutlet UISwitch *sexSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (assign, nonatomic) NSInteger gender;//性别0=女，1=男
@property (assign, nonatomic) NSInteger status;//身份0=教师，1=学生，2=其他




@property (strong, nonatomic) NSString *secretPass;



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.sexSwitch addTarget:self action:@selector(clickSexBtn:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl addTarget:self action:@selector(clickRegisterStatusBtn:) forControlEvents:UIControlEventValueChanged];

    self.segmentControl.tintColor = [UIColor colorWithRed:0.015686 green:0.545098 blue:0.984313 alpha:1];
    self.confirmPass.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.gender = 0;
    self.status = 0;
//    [self setUpTextRightView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.confirmPass) {
        [self getSecretPasswd];
    }
}

- (void)setUpTextRightView
{
    UIImageView *userView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"must.png"]];
    userView.frame = CGRectMake(0, 0, 55, 20);
    userView.contentMode = UIViewContentModeCenter;
    self.userName.rightViewMode = UITextFieldViewModeAlways;
    self.userName.rightView = userView;
    
    self.passWord.rightViewMode = UITextFieldViewModeAlways;
    self.passWord.rightView = userView;
    
    self.confirmPass.rightViewMode = UITextFieldViewModeAlways;
    self.confirmPass.rightView = userView;

    self.phoneNum.rightViewMode = UITextFieldViewModeAlways;
    self.phoneNum.rightView = userView;
    
    self.realNmae.rightViewMode = UITextFieldViewModeAlways;
    self.realNmae.rightView = userView;
    
    self.mailAdd.rightViewMode = UITextFieldViewModeAlways;
    self.mailAdd.rightView = userView;
    
    self.idNum.rightViewMode = UITextFieldViewModeAlways;
    self.idNum.rightView = userView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userName endEditing:YES];
    [self.passWord endEditing:YES];
    [self.confirmPass endEditing:YES];
    [self.phoneNum endEditing:YES];
    [self.realNmae endEditing:YES];
    [self.mailAdd endEditing:YES];
    [self.idNum endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)clickSexBtn:(id)sender {

    UISwitch *sexSwitch = (UISwitch *)sender;
    if (sexSwitch == self.sexSwitch) {
        BOOL on = sexSwitch.on;
        if (on) {
            //女
            
            self.gender = 0;
            
        } else {
            //男
            self.gender = 1;
            
            
        }
    }
    
    
}


- (void)clickRegisterStatusBtn:(UISegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            self.status = 0;
            break;
        case 1:
            self.status = 1;
            break;
        case 2:
            self.status = 2;
            break;
            
        default:
            break;
    }
}



- (IBAction)clickRegisterButton:(id)sender {
    [self registAccountButton];
//    [self getSecretPasswd];
    
    if (!self.secretPass) {
        return;
    }
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.userName.text, @"username", self.secretPass, @"userpass", self.phoneNum.text, @"userphone", self.realNmae.text, @"realname", self.mailAdd.text, @"useremail", self.idNum.text, @"usersfzh", self.status,@"usertype",self.gender,@"sex",nil];
    
    NSString *url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=userregister&username=%@&userpass=%@&usersfzh=%@&useremail=%@&userphone=%@&usertype=%ld&realname=%@&sex=%ld",self.userName.text,self.secretPass,self.idNum.text,self.mailAdd.text,self.phoneNum.text,self.status,self.realNmae.text,self.gender];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"issuccess"] isEqualToString:@"false"]) {
            [FormValidator showAlertWithStr:@"您已经注册过了"];
        } else {
            [FormValidator showAlertWithStr:@"注册成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [FormValidator showAlertWithStr:@"网络开小差，请您再刷新一下"];
    }];
    
    
}

- (void)registAccountButton
{
    
    NSString *phoneNum = [FormValidator checkMobile:self.phoneNum.text];
    NSString *passWord = [FormValidator checkPassword:self.passWord.text];
    NSString *confirmPass = [FormValidator checkPassword:self.confirmPass.text];
    
    if (self.userName.text == nil || [self.userName.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"用户名不能为空"];
        return;
    } else if(self.passWord.text == nil || [self.passWord.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"密码不能为空"];
        return;
    } else if (self.confirmPass.text == nil || [self.confirmPass.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"确认密码不能为空"];
        return;
    } else if (self.phoneNum.text == nil || [self.phoneNum.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"手机号不能为空"];
        return;
    } else if (self.idNum.text == nil || [self.idNum.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"身份证号不能为空"];
    } else if (self.realNmae.text == nil || [self.realNmae.text isEqualToString:@""]) {
        [FormValidator showAlertWithStr:@"姓名不能为空"];
    } else if (phoneNum || passWord || confirmPass) {
        [FormValidator showAlertWithStr:@"电话号码／密码／确认密码格式不正确"];
        return;
    }
}

//获取加密后的密码串
- (void)getSecretPasswd
{

    NSString *url2 = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=encrypt&str=%@", self.passWord.text];
    
    
//    __block NSString *pass = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url2 parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.secretPass = [responseObject objectForKey:@"date"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
//    return pass;
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

- (IBAction)menBtn:(id)sender {
}
@end
