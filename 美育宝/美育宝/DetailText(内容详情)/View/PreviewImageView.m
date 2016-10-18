//
//  PreviewPhotoView.m
//
//
//  Created by Joywii on 13-10-16.
//  Copyright (c) 2013年 Joywii. All rights reserved.
//

#import "PreviewImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CatZanButton.h"
#import "AFNetworking.h"

#define kZanX self.frame.size.width - 100
#define kZanY self.frame.size.height - 80
#define kZanLabelX self.frame.size.width - 45
#define kZanLabelY self.frame.size.height - 65

@interface PreviewImageView ()<UIActionSheetDelegate>
{
    NSString *_userCode;
    NSString *_classID;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) NSValue *starRectValue;
@property (nonatomic,strong) NSValue *imageRectValue;
@property (nonatomic,strong) UILabel *label;
@end

@implementation PreviewImageView

+ (void)showPreviewImage:(UIImage *)image startImageFrame:(CGRect)startImageFrame inView:(UIView *)inView viewFrame:(CGRect)viewFrame
{
    PreviewImageView *preImageView = [[PreviewImageView alloc] initWithFrame:viewFrame withImage:image startFrame:startImageFrame];
    [inView addSubview:preImageView];
}
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image startFrame:(CGRect)startFrame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
        
        self.starRectValue =  [NSValue valueWithCGRect:startFrame];
        
        self.contentView = [[UIView alloc] initWithFrame:startFrame];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.userInteractionEnabled = YES;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 3.0;
        [self addSubview:self.contentView];
        
        CGRect imageFrame = startFrame;
        imageFrame.origin.x = 0;
        imageFrame.origin.y = 0;
        self.imageRectValue = [NSValue valueWithCGRect:imageFrame];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImageView.image = image;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImageView];
        
        [self addTapPressGestureRecognizer];
        [self addLongPressGestureRecognizer];
        
        [UIView beginAnimations:@"backgroundcolor" context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.backgroundColor = [UIColor blackColor];
        [UIView commitAnimations];
        
        [self startShowAnimation];
    }
    return self;
}
- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    [self startHideAnimation];
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.4];
}
- (void)hide
{
    [self removeFromSuperview];
}
- (void)startShowAnimation
{
    [UIView beginAnimations:@"scaleImageShow" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    [UIView commitAnimations];
}
- (void)startHideAnimation
{
    [UIView beginAnimations:@"scaleImageHide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = [self.imageRectValue CGRectValue];
    self.contentView.frame = [self.starRectValue CGRectValue];
    self.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
}
- (void)addTapPressGestureRecognizer
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    
    tapGR.cancelsTouchesInView = NO;
	tapGR.delaysTouchesBegan = NO;
	tapGR.delaysTouchesEnded = NO;
	tapGR.numberOfTapsRequired = 1;
	tapGR.numberOfTouchesRequired = 1;
    
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self addGestureRecognizer:tapGR];
//    显示点赞数的label
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(kZanLabelX, kZanLabelY, 30, 21)];
    self.label.text = [self numberOfZan];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:20.0f];
    self.label.backgroundColor = [UIColor redColor];
    [self addSubview:self.label];
//    点赞按钮
    CatZanButton *zanBtn=[[CatZanButton alloc] initWithFrame:CGRectMake(kZanX, kZanY, 50, 50)];
    //[zanBtn setCenter:self.view.center];
    [self addSubview:zanBtn];
    
    [zanBtn setType:CatZanButtonTypeFirework];
//    点击事件
    [zanBtn setClickHandler:^(CatZanButton *zanButton) {
        if (zanButton.isZan) {
            NSLog(@"Zan!");
            
            [self clickZanButton];
            
        }else{
            NSLog(@"Cancel zan!");
        }
    }];
    
}
- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleLongPress:)];
    
    [longPressGR setMinimumPressDuration:0.4];
    [self addGestureRecognizer:longPressGR];
    
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"微信好友",@"朋友圈",@"保存到相册",nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        action.tag = 123456;
        
        [action showInView:self];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 123456 && buttonIndex == 2)
    {
        if (self.photoImageView.image)
        {
            UIImageWriteToSavedPhotosAlbum(self.photoImageView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
        
        else
        {
            NSLog(@"image is nil");
        
        }
    } else if (buttonIndex == 0)
    {
        NSLog(@"0000");
        NSNotification *notification = [NSNotification notificationWithName:@"WECHATFRIENDS" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } else if (buttonIndex == 1) {
        NSLog(@"1111");
        NSNotification *notification = [NSNotification notificationWithName:@"WECHATFRIENDSCIRLE" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"%@",error);
    }
    else
    {
        NSLog(@"save success!");
    }
}

- (void)clickZanButton
{
    //http://192.168.3.254:8082/GetDataToApp.aspx?action=zpdianzan&mxdm=a2222ed3-cec4-4927-84a9-82354774f169&usercode=
    [self getDataFilePath];
    //点赞的url
    NSString *clickZanUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=zpdianzan&mxdm=%@&usercode=%@",_classID, _userCode];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:clickZanUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *str = [responseObject objectForKey:@"issuccess"];
        if ([str isEqualToString:@"true"]) {
            [self numberOfZan];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

//获取点赞数
- (NSString *)numberOfZan
{
    //http://192.168.3.254:8082/GetDataToApp.aspx?action=getzpdianzans&mxdm=a2222ed3-cec4-4927-84a9-82354774f169
    if ( !_userCode || !_classID) {
        [self getDataFilePath];
    }
    NSString *countZanUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzpdianzans&mxdm=%@",_classID];
    __block NSString *zan = nil;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:countZanUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        zan = [responseObject objectForKey:@"date"];
        self.label.text = zan;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    return zan;
}



- (void)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    
    NSString *login = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _classID = [path objectAtIndex:0];
        
    }
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:login]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:login];
        _userCode = [path objectAtIndex:2];
        
    }
    
}

@end
