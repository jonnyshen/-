//
//  UploadWorksDisplayController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/13.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "UploadWorksDisplayController.h"
#import "ClassifiedWorksUploadCon.h"
#import "FormValidator.h"

@interface UploadWorksDisplayController ()<NSURLSessionDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *_headerImage;
    NSData *_imageData;
    NSString *_imageDataString;
    NSString *_imageName;
}
//是否可拍摄视频
@property (nonatomic) BOOL isNeedMovie;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;



@end

@implementation UploadWorksDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"作品上传";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    
    
    [self.uploadBtn addTarget:self action:@selector(setUploadWorksBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    头部视图添加点击事件
    self.headerImageView.image = [UIImage imageNamed:@"001.jpg"];
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapViewWithAction:)];
    [self.headerImageView addGestureRecognizer:tapGR];
}

- (void)handleTapViewWithAction:(UIGestureRecognizer *)gesture
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"作品上传" message:@"选择上传方式" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *phoneAlbum = [UIAlertAction actionWithTitle:@"手机相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self getPhotoFromBlum];
        
        
       
    }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isNeedMovie = NO;
        [self getPhotoFromCamera];
    }];
    
    UIAlertAction *phoneRecord = [UIAlertAction actionWithTitle:@"录制视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.isNeedMovie = YES;
        [self getPhotoFromCamera];
    }];
    
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
    //    picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
    picker.delegate      = self;
    //
    //    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    picker.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    if (self.isNeedMovie)
    {
//        [arr addObject:(NSString *)kUTTypeMovie];
    }
//    picker.mediaTypes = arr;
    
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


#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //压缩图片
    NSData *fileData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    _imageDataString = [fileData base64EncodedStringWithOptions:0];
    
    self.headerImageView.image = image;
    
    /*
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

     */
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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





















- (void)setUploadWorksBtnAction:(UIButton *)button
{
    if ([self.detailTextField.text isEqualToString:@""] || self.detailTextField.text == nil) {
        [FormValidator showAlertWithStr:@"请对作品进行一定的说明"];
    }
    ClassifiedWorksUploadCon *worksUpload = [[ClassifiedWorksUploadCon alloc] initWithImageData:_imageDataString classDecribe:self.detailTextField.text];
    [self.navigationController pushViewController:worksUpload animated:YES];
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
