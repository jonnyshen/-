//
//  UploadSourceDisplayController.m
//  美育宝
#import "UploadSourceDisplayController.h"
#import "SourceController.h"
#import "MYToolsModel.h"
#import "AFNetworking.h"
#import "FormValidator.h"
#import "ClassifiedCatalogueController.h"

@interface UploadSourceDisplayController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *_headerImage;
    NSData *_imageData;
    NSString *_imageDataString;
    NSString *_imageName;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

//是否可拍摄视频
@property (nonatomic) BOOL isNeedMovie;

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
    self.title = @"资源上传";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [self.uploadBtn addTarget:self action:@selector(setUploadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取系统时间戳
    NSDate *dateTime = [NSDate date];//获取时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //用来设置时间格式
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];//设置时间格式,也是时间戳
    NSString * date = [dateFormatter stringFromDate:dateTime];
    _imageName = [[NSString stringWithFormat:@"%@.png",date] substringFromIndex:2];
    self.titleLabel.text = _imageName;
    
    // 头部视图添加点击事件
    self.headerImageView.image = [UIImage imageNamed:@"001.jpg"];
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    //点击图片 手势触动的手势点击方法，此方法中打开 UIAlertController （手机相册，拍照，录制视频，取消）
    [tapGR addTarget:self action:@selector(handleTapViewWithAction:)];
    [self.headerImageView addGestureRecognizer:tapGR];
    
}

- (void)handleTapViewWithAction:(UIGestureRecognizer *)gestureRecognizer
{
    [self.detailTextField resignFirstResponder];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"作品上传" message:@"请选择获取资源方式" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *phoneAlbum = [UIAlertAction actionWithTitle:@"手机相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
         // 打开手机相册
        [self getPhotoFromBlum];
    }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isNeedMovie = NO;
        // 拍照
        [self getPhotoFromCamera];
    }];
    
    UIAlertAction *phoneRecord = [UIAlertAction actionWithTitle:@"录制视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isNeedMovie = YES;
        // 录制视频
        [self getPhotoFromCamera];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:phoneAlbum];
    [alertController addAction:takePhoto];
    [alertController addAction:phoneRecord];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)getPhotoFromBlum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate      = self;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
-(void)getPhotoFromCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate      = self;
    //
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认15s
    picker.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    if (self.isNeedMovie)
    {
        [arr addObject:(NSString *)kUTTypeMovie];
    }
    picker.mediaTypes = arr;
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


#pragma mark - 打开相册代理方法 （这里可以拿到点击的图片）

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //压缩图片
    NSData *fileData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    _imageDataString = [fileData base64EncodedStringWithOptions:0];
    
    self.headerImageView.image = image;
    
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        //压缩图片
        //        NSData *fileData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
        
        //不压缩图片
        NSData *fileData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
        _imageDataString = [fileData base64EncodedStringWithOptions:0];
        
        self.headerImageView.image = image;
        
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        //        上传图片
        
    }else{
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr))
            {
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //视频上传
        _imageDataString = [videoData base64EncodedStringWithOptions:0];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消 退出相册
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"保存完毕");
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
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
    
    UIAlertAction *temporaryUploadAction = [UIAlertAction actionWithTitle:@"上传临时空间" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        上传临时空间方法
        [self uploadTemporarySpace];
        
    }];
    
    UIAlertAction *detailMessageAction = [UIAlertAction actionWithTitle:@"选定目录上传" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        ClassifiedCatalogueController *catalogue = [[ClassifiedCatalogueController alloc] initWithImage:_imageName andImageData:_imageDataString classDecribe:self.detailTextField.text];
        [self.navigationController pushViewController:catalogue animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertConroller addAction:temporaryUploadAction];
    [alertConroller addAction:detailMessageAction];
    [alertConroller addAction:cancelAction];
    [self presentViewController:alertConroller animated:YES completion:nil];
    
}

// 上传临时空间
- (void)uploadTemporarySpace
{
    [self createFieldName:_imageName];
    
    //
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    
    NSString *imgData_Length = [NSString stringWithFormat:@"%ld",_imageDataString.length];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savezy&usercode=%@&jyjd=&kch=&nj=&zbh=&zymc=%@&filename=%@&filesize=%@&zyms=&zybh=",userCode,_imageName,_imageName,imgData_Length];
        
//        SourceController * vc = [[SourceController alloc] init];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:saveUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            issuccess服务器字段
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                [FormValidator showAlertWithStr:@"保存成功"];
                
//               [self presentViewController:vc animated:YES completion:^{
//                   
//               }];
                [self.navigationController popViewControllerAnimated:YES];
             
           }
//            else {
//               [FormValidator showAlertWithStr:@"保存失败"];
//            }
//
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [FormValidator showAlertWithStr:@"保存失败"];
        }];
        
        
        
    });
    
}



//发起上传请求，创建文件夹
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

//上传 图片
- (void)imageName:(NSString *)name
{
    //可以打印看看 这个路径
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    
    NSString *appendingStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AppendToFile xmlns=\"http://tempuri.org/\"><fileName>%@</fileName><buffer>%@</buffer><type>%@</type></AppendToFile></soap:Body></soap:Envelope>",name,_imageDataString,@"2"];
    
    NSString *appending_File_Length = [NSString stringWithFormat:@"%ld",appendingStr.length];
    
    
    NSMutableURLRequest *appendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file_Name_Url]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [appendRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"content-type"];
    [appendRequest addValue:appending_File_Length forHTTPHeaderField:@"content-length"];
    [appendRequest addValue:@"http://tempuri.org/AppendToFile" forHTTPHeaderField:@"SOAPAction"];
    [appendRequest setHTTPMethod:@"POST"];
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLSessionUploadTask *appendDataTask = [manager uploadTaskWithRequest:appendRequest fromData:[appendingStr dataUsingEncoding:NSUTF8StringEncoding] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error)
                NSLog(@"Error: %@", error);
            else
                NSLog(@"%@",response);
            
            NSLog(@"----->%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         }];
        [appendDataTask resume];
        
    });
}

@end
