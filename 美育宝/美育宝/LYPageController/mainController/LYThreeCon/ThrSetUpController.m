//
//  ThrSetUpController.m
//  Page Demo
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ThrSetUpController.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "CoolNavi.h"
#import "MYToolsModel.h"
#import "FindPassWordController.h"
#import "MYWeiDuIntroduceController.h"

static CGFloat const kWindowHeight = 205.0f;
static NSUInteger const kCellNum = 2;
static NSUInteger const kRowHeight = 44;
static NSString * const kCellIdentify = @"cell";

@interface ThrSetUpController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ThrSetUpController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    MYToolsModel *tools      = [MYToolsModel new];
    NSString *headerImageURL = [tools sendFileString:@"LoginData.plist" andNumber:7];
    NSString *title          = [tools sendFileString:@"LoginData.plist" andNumber:6];
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    CoolNavi *headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kWindowHeight)backGroudImage:@"background" headerImageURL:headerImageURL title:title subTitle:@"彪悍的人生不需要解释！"];
    headerView.scrollView = self.tableView;
    headerView.imgActionBlock = ^(){
        NSLog(@"headerImageAction");
        [self setUpHeaderImage];
    };
    
    headerView.backButtonActionBlock = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:headerView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentify];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - tableView Delegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 1;
    }
    return kCellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
    
    
    
    
    if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:25];
        cell.textLabel.textColor = [UIColor blackColor];
        
    } else if(indexPath.section == 0 && indexPath.row == 0) {
       cell.textLabel.text = @"找回密码";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.imageView.image = [UIImage imageNamed:@"art_sub08.png"];
    } else {
         cell.textLabel.text = @"关于伟度科技";
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.imageView.image = [UIImage imageNamed:@"do_work.png"];
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 50;
    }
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [LoginState setLoginOuted];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else if (indexPath.row == 0) {
        FindPassWordController *find = [[FindPassWordController alloc] init];
//        find = [[UIStoryboard storyboardWithName:@"Three" bundle:nil] instantiateViewControllerWithIdentifier:@"FindPassWordController"];
        [self.navigationController pushViewController:find animated:YES];

    }else {
        MYWeiDuIntroduceController *introduce = [[MYWeiDuIntroduceController alloc] init];
        [self.navigationController pushViewController:introduce animated:YES];
    }
    
}


#pragma mark - 设置头像
- (void)setUpHeaderImage
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraPicture = [UIAlertAction actionWithTitle:@"直接拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.delegate = self;
            ipc.allowsEditing = YES;
            ipc.navigationBar.barTintColor =[UIColor whiteColor];
            ipc.navigationBar.tintColor = [UIColor whiteColor];
//            ipc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor]};
            
            [ipc.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
            [self presentViewController:ipc animated:YES completion:^{
                ipc = nil;
            }];
        } else {
            NSLog(@"模拟器无法打开照相机");
        }
    }];
    
    UIAlertAction *photoImage = [UIAlertAction actionWithTitle:@"从手机相片选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __block UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        picker.navigationBar.barTintColor =[UIColor whiteColor];
        picker.navigationBar.tintColor = [UIColor blackColor];
        [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [self presentViewController:picker animated:YES completion:^{
            picker = nil;
        }];
        
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cameraPicture];
    [alertCon addAction:photoImage];
    [alertCon addAction:cancelButton];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //完成选择
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type:%@",type);
    if ([type isEqualToString:@"public.image"]) {
        //转换成NSData
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            //设置头像
            //            [_head setImage:image forState:UIControlStateNormal];
            //上传头像
//            [self updatePhotoFor:image];
        }];
        
    }
}


#pragma mark --头像上传
-(void)updatePhoto:(NSString *)base64Str
{
    //    NSString *url =[NSString stringWithFormat:@"%@%@",Host_DSXVipManager,@"/service/member"];
    //
    //    NSDictionary *dict = @{@"action":@"avatar",@"owner":@"guide",@"username":[UserModel getUserDefaultLoginName],@"password":[UserModel getUserDefaultPassword],@"filename":@"head.jpg",@"data":base64Str,@"operId":[UserModel getUserDefaultId],@"operType":@"guide"};
    //    [[NetRequestManager sharedInstance] sendRequest:[NSURL URLWithString:url] parameterDic:dict requestTag:0 delegate:self userInfo:nil];
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
