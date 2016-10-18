//
//  LYPlayerViewController.m
//  Page Demo
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYPlayerViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "CDPVideoPlayer.h"
#import "FormValidator.h"

#import "directionModel.h"
#import "introduceModel.h"
#import "XSMediaPlayerMaskView.h"
#import "XSMediaPlayer.h"
#import "IntroduceViewController.h"
#import "DirectionViewController.h"
#import "CommentViewController.h"
#import "NotesViewController.h"
#import "MYHttpRequestTools.h"
#import "MYToolsModel.h"
#import "JWShareView.h"
//#import "ShareCollectView.h"


#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width
#define kAddViewX kView_H - 20- 200 - 70 - 49

//#define kNavigationFrame self.navigationController.view.frame
#define kPageCount 4
#define kButton_H 70 //90
#define kMrg 0
#define kTag 100
#define kPlayerH 200
#define kPlayerY 20
#import "KRVideoPlayerControlView.h"
#import "Vitamio.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DurationFormat.h"

#define CDPSWIDTH   [UIScreen mainScreen].bounds.size.width
#define CDPSHEIGHT  [UIScreen mainScreen].bounds.size.height

//上下导航栏高(全屏时上导航栏高+20)
#define CDPTOPHEIGHT(FullScreen) ((FullScreen==YES)?60:40)
#define CDPFOOTHEIGHT 40

//导航栏上button的宽高
#define CDPButtonWidth 30
#define CDPButtonHeight 30

//导航栏隐藏前所需等待时间
#define CDPHideBarIntervalTime 3

NSString *const VPVCPlayerItemReadyToPlayNotification = @"VPVCPlayerItemReadyToPlayNotification";
NSString *const VPVCPlayerItemDidPlayToEndTimeNotification = @"VPVCPlayerItemDidPlayToEndTimeNotification";
//static const CGFloat kVideoPlayerControllerAnimationTimeInterval = 0.3f;

@interface LYPlayerViewController ()<UIScrollViewDelegate,CDPVideoPlayerDelegate, VMediaPlayerDelegate>
{
    NSString *_classID;//课程ID
    NSString *_fromVC;//来自哪一个控制器
    NSString *_videoURL;//URLpath 全路径不行拼接
    CDPVideoPlayer *_player;
    
    VMediaPlayer *mplayer;
    BOOL didPrepare;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    CGFloat playerProgress; // 播放进度
    
    // 手势初始X和Y坐标
    CGFloat beginTouchX;
    CGFloat beginTouchY;
    // 手势相对于初始X和Y坐标的偏移量
    CGFloat offsetX;
    CGFloat offsetY;
    
    NSString *userCode;
    NSString *pwd;
    
    UIButton *button;
    NSString *videoTitle;//视频名字
    
}

@property (nonatomic, strong) NSMutableArray *tempArrA;
@property (nonatomic, strong) NSMutableArray *tempArrB;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *pageLine;
@property (nonatomic, assign) NSInteger currentPages;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) IntroduceViewController *first;
@property (nonatomic , strong) DirectionViewController *second;
//@property (nonatomic , strong) CommentViewController *three;
@property (nonatomic , strong) NotesViewController *four;
@property (nonatomic, strong) KRVideoPlayerControlView *playerView;
@property (nonatomic, strong) UIView *movieBackgroundView;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic) long currentVideoItemDuration;
@property (nonatomic) BOOL videoProgressSliderOnTouched;
@property (nonatomic) BOOL hasPreparedToPlay;
@property (nonatomic) BOOL playAfterPrepared;
@property (nonatomic) NSTimer *videoStatusPullTimer;
//@property (nonatomic, strong) NSUserDefaults *defaults;
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,assign)CGFloat systemVolume;
@property(nonatomic,strong)UISlider *volumeViewSlider;


@end

@implementation LYPlayerViewController


-(instancetype)initWithVideoId:(NSString *)classID andComeFromWhichVC:(NSString *)vc{
    self = [super init];
    if (!self)  return nil;
    _fromVC  = vc;
    _classID = classID;
    return self;
}

- (instancetype)initWithVideoURL:(NSString *)videoURL andComeFromWhichVC:(NSString *)vc
{
    self = [super init];
    if (!self)  return nil;
    _videoURL = videoURL;
    _fromVC   = vc;
    return self;
}

- (instancetype)initWithVideoURL:(NSString *)videoURL videoID:(NSString *)vid andComeFromWhichVC:(NSString *)vc
{
    self = [super init];
    if (!self)  return nil;
    _videoURL = videoURL;
    _classID  = vid;
    _fromVC   = vc;
    return self;
}

- (void)loadView
{
    [super loadView];
    //网络请求
    [self httpRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //设置可以左右滑动的ScrollView
    [self setupScrollView];
    
    //设置控制的每一个子控制器
    [self setupChildViewControll];
    
    //设置分页按钮
    [self setupPageButton];
    
    
    //
    [self bottomBarUIAction];
    
    //播放器
    [self createUI];
    //[_player player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"WSTableView_FILE_PATH" object:nil];
    [self bottomBarUIAction];
    
}


- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _classID = [path objectAtIndex:0];
        
    }
    
    return _classID;
}

- (void)httpRequest
{
    if (!_classID) {
        _classID = [self getDataFilePath];
    }
    
    NSString *url = nil;
//  TWO代表第二个控制器（课程中心）传过来
    if ([_fromVC isEqualToString:@"TWO"]) {
        url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkcinfo&kcid=%@",_classID];
    } else {
        url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxbkcinfo&kcid=%@", _classID];
    }
    //    NSLog(@"^^^^^^%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (self.dataDic) {
            [self.tempArrB removeAllObjects];
        }
        
        videoTitle    = responseObject[@"KCXX"][@"KCMC"];
        self.playerView.titleLabel.text = videoTitle;
        
        self.tempArrB = [NSMutableArray array];
        
        NSArray *textArr = responseObject[@"ZJML"];
        
        if ([textArr.firstObject isKindOfClass:[NSString class]]) {
            
            [FormValidator showAlertWithStr:@"暂无播放数据"];
            return;
            
        } else {
            for (NSDictionary *dic in responseObject[@"ZJML"]) {
                directionModel *direction = [[directionModel alloc] init];
                
                NSArray *arrParam = dic[@"KS"];
                for (NSDictionary *param in arrParam) {
                    
                    direction.videoFilePath = param[@"filePath"];
                    
                }
                
                [self.tempArrB addObject:direction];
            }
            
            //        NSLog(@"player---%@",self.tempArrB);
            
            [self.dataDic setValue:self.tempArrB forKey:@"B"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //        NSLog(@"PLAYER--%@",error.userInfo);
    }];
}

- (void)bottomBarUIAction
{
    [self.joinClass addTarget:self action:@selector(clickJoinClass) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectBtn addTarget:self action:@selector(collectGoodClass) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)collectGoodClass
{
    [self getLoginDataFilePath];
    //    MYHttpRequestTools *httptools = [[MYHttpRequestTools alloc]init];
    NSString *toolsString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savesc&ucode=%@&upwd=%@&sjid=%@&type=1",userCode, pwd, _classID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:toolsString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            
            self.collectBtn.backgroundColor = [UIColor blueColor];
        } else {
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)clickJoinClass
{
    self.joinClass.backgroundColor = self.joinClass.selected?[UIColor blueColor]:[UIColor whiteColor];
    [self getLoginDataFilePath];
    NSString *joinClassUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=joincourse&ucode=%@&upwd=%@&kcid=%@&ksh=%@&state=%@&sjlx=%@",userCode, pwd, _classID, @"", @"0", @"0"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:joinClassUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            
            self.joinClass.backgroundColor = [UIColor blueColor];
        } else {
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
    
}

//分享的点击
- (void)shareBtnClick
{
    
    NSArray *contentArray = @[@{@"name":@"新浪微博",@"icon":@"sns_icon_3"},
                              @{@"name":@"QQ空间 ",@"icon":@"sns_icon_5"},
                              @{@"name":@"QQ",@"icon":@"sns_icon_4"},
                              @{@"name":@"微信",@"icon":@"sns_icon_7"},
                              @{@"name":@"朋友圈",@"icon":@"sns_icon_8"},
                              @{@"name":@"微信收藏",@"icon":@"sns_icon_9"}];
    JWShareView *shareView = [[JWShareView alloc] init];
    [shareView addShareItems:self.view shareItems:contentArray selectShareItem:^(NSInteger tag, NSString *title) {
        NSLog(@"%ld --- %@", tag, title);
    }];
    
}

- (void)getLoginDataFilePath
{
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        userCode = [path objectAtIndex:2];
        pwd = [path objectAtIndex:1];
    }
    
}

-(void)dealloc{
    //关闭播放器并销毁当前播放view
    //一定要在退出时使用,否则内存可能释放不了
    [_player close];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.view.backgroundColor=[UIColor lightTextColor];
}
-(BOOL)shouldAutorotate{
    return NO;
}
#pragma mark - 创建UI
-(void)createUI{
    
    //播放器
    self.playerView = [[KRVideoPlayerControlView alloc] initWithFrame:CGRectMake(0, kPlayerY,kView_W, kPlayerH)];
    self.playerView.titleLabel.text = videoTitle;
    
    [self.view.layer addSublayer:self.playerView.layer];
    
    [self.view addSubview:self.playerView];
    
    if (!mplayer) {
        mplayer = [VMediaPlayer sharedInstance];
        [mplayer setupPlayerWithCarrierView:self.playerView withDelegate:self];
    }
    
    [self createPlayerAction];
    
    
    
}
#pragma mark - CDPVideoPlayerDelegate
//非全屏下返回点击(仅限默认UI)
-(void)back{
    [self backClick];
}
#pragma mark - 点击事件
//返回
-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tongzhi:(NSNotification *)notic
{
    //    NSString *videoPath = notic.userInfo[@"videoPath"];
    //    [mplayer pause];
    //    [mplayer reset];
    
    //    [mplayer setDataSource:[NSURL URLWithString:videoPath]];
    //    [mplayer prepareAsync];
    
    [mplayer isPlaying];
}

-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}


- (void)playerWithVideoPath
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    NSString *videoString = nil;
    if ([_fromVC isEqualToString:@"THREE"]) {
        NSString *imgString = [tools sendFileString:@"Three.plist" andNumber:0];
        
        if (_classID.length > 6) {
            NSString *pieceStr = [_classID substringWithRange:NSMakeRange(0, 6)];
            videoString = [NSString stringWithFormat:@"%@%@/%@",imgString, pieceStr,_classID];
        }
        
    } else if([_fromVC isEqualToString:@"VIDEOURL"]){
        
        videoString = _videoURL;
        
    } else {
        if (self.tempArrB.count > 0) {
            directionModel *direction = [self.tempArrB firstObject];
            videoString = direction.videoFilePath;
            
        }
    }
    
    if (!videoString) {
        [FormValidator showAlertWithStr:@"无法播放视频"];
        return;
    }
#warning 播放路径赋值
    [mplayer setDataSource:[NSURL URLWithString:videoString]];
    [mplayer prepareAsync];
    self.playAfterPrepared = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     //视频播放的方法。。。。
    [self playerWithVideoPath];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.scroll.delegate = nil;
    _player.delegate     = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self closePlayer];
    
}

- (void)closePlayer
{
    [self.videoStatusPullTimer invalidate];
    self.playAfterPrepared = NO;
    self.hasPreparedToPlay = NO;
    
    [mplayer pause];
    //    [mplayer reset];
    [mplayer unSetupPlayer];
    
}

#pragma mark -  VMediaPlayerDelegate
- (void)mediaPlayer:(VMediaPlayer *)player info:(id)arg
{
    didPrepare = NO;
    [player reset];
}

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    
    didPrepare = YES;
    
    //[self refreshCurrentPlayProgress];
    
    [player start];
    
    //    NSLog(@"mediaPlayer:didPrepared");
    self.hasPreparedToPlay = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VPVCPlayerItemReadyToPlayNotification object:self];
    //
    self.currentVideoItemDuration = [player getDuration];
    //    NSLog(@"----->>>%ld",self.currentVideoItemDuration);
    //    NSString *text = [DurationFormat durationTextForDuration:(self.currentVideoItemDuration/1000.f)];
    
    if (self.playAfterPrepared) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [mplayer start];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            //[self dismissPlayerNavAndControlPanel];
            //            //[self setPlayButttonPaused];
            [self stopActivityLoading];
            [self refreshCurrentPlayProgress];
            
            [self.videoStatusPullTimer invalidate];
            self.videoStatusPullTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/3
                                                                         target:self
                                                                       selector:@selector(pulledVideoStatus:)
                                                                       userInfo:nil
                                                                        repeats:YES];
        });
    }
    
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    //    NSLog(@"%@",arg);
    //    NSLog(@"play failed, err: %@", arg);
    self.hasPreparedToPlay = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityLoading];
        
    });
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    
    //    NSLog(@"playbackComplete");
    
    self.hasPreparedToPlay = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoStatusPullTimer invalidate];
        [self resetPlayControlView];
    });
    
    [mplayer pause];
    [mplayer seekTo:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VPVCPlayerItemDidPlayToEndTimeNotification
                                                        object:self];
    
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    // Set buffer size, default is 1024KB(1*1024*1024).
    //	[player setBufferSize:256*1024];
    [player setBufferSize:1024*1024];
    
    [player setVideoQuality:VMVideoQualityMedium];
    
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    //    NSLog(@"seekComplete");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityLoading];
    });
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    //    NSLog(@"notSeekable");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityLoading];
    });
}

- (void)createPlayerAction
{
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
    
    //双击
    UITapGestureRecognizer *doubleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    doubleGR.numberOfTouchesRequired = 1;
    doubleGR.numberOfTapsRequired = 2;
    [self.playerView addGestureRecognizer:doubleGR];
    //全屏按钮点击
    [self.playerView.fullScreenButton addTarget:self action:@selector(playerViewFullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
     //小屏
    [self.playerView.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView.playButton addTarget:self action:@selector(playerViewPlayerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    
    [self.playerView.progressSlider addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    [self.playerView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 手势点击
//单双击
-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    if(tapGR.numberOfTapsRequired == 2) {
        //双击
        if (self.isFullscreenMode) {
            [self shrinkScreenButtonClick];
        } else {
            [self playerViewFullScreenButtonClick];
        }
    }
}

- (void)playerViewFullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    //    NSLog(@"=================");
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    self.btn.hidden = YES;
    self.scroll.hidden = YES;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    
    self.originFrame = self.view.frame;
    
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    
    //CGRect frame = CGRectMake(0, 0, width, height);
    
    [UIView animateWithDuration:0.3f animations:^{
        //self.playerView.isFullScreen = YES;
        self.frame = frame;
        
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.playerView.fullScreenButton.hidden = YES;
        self.playerView.shrinkScreenButton.hidden = NO;
    }];
    [self didSetFullScreenCanvas];
    
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.playerView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.playerView setNeedsLayout];
    [self.playerView layoutIfNeeded];
}

- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }
    self.btn.hidden = NO;
    self.scroll.hidden = NO;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        _playerView.frame = CGRectMake(0, kPlayerY,CDPSWIDTH, kPlayerH);
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        self.playerView.fullScreenButton.hidden = NO;
        self.playerView.shrinkScreenButton.hidden = YES;
    }];
    
    [self restoreOrChangeTransForm:YES];
    [self restoreOrChangeFrame:YES];
}

- (void)pauseButtonClick
{
    if (didPrepare) {
        [mplayer start];
        self.playerView.playButton.hidden = NO;
        self.playerView.pauseButton.hidden = YES;
        [self mediaPlayer:mplayer didPrepared:@{@YES:@"didPrepare"}];
    } else {
        [mplayer prepareAsync];
    }
}

- (void)playerViewPlayerButtonClick
{
    //    NSLog(@"-----------------------");
    [mplayer pause];
    self.playerView.playButton.hidden = YES;
    self.playerView.pauseButton.hidden = NO;
    
}

- (void)closeButtonClick
{
    if (self.isFullscreenMode) {
        [self shrinkScreenButtonClick];
        [mplayer pause];
        self.playerView.pauseButton.hidden = NO;
        self.playerView.playButton.hidden = YES;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    //    NSLog(@"========2222=========");
    [mplayer pause];
    [self.playerView cancelAutoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider
{
    [mplayer pause];
    self.playerView.pauseButton.hidden = NO;
    self.playerView.playButton.hidden = YES;
    
    //CGFloat currentTime = [self currentVideoPlayPosition]/1000.f;
    CGFloat videoDur = self.currentVideoItemDuration/1000.f;
    CGFloat currentTime = videoDur * self.playerView.progressSlider.value;
    NSString *nowTime = [DurationFormat durationTextForDuration:currentTime];
    NSString *videoTime = [DurationFormat durationTextForDuration:videoDur];
    self.playerView.timeLabel.text = [NSString stringWithFormat:@"%@/%@",nowTime, videoTime];
    [self seekToPosition:currentTime];
    self.playerView.progressSlider.value = currentTime/videoDur;
    
}

- (void)progressSliderTouchEnd:(UISlider *)slider
{
    //     CGFloat videoDur = self.currentVideoItemDuration/1000.f;
    //    CGFloat currentTime = videoDur * self.playerView.progressSlider.value;
    //    [self seekToPosition:currentTime];
}



// 是否在播放
- (BOOL)isPlaying
{
    return mplayer.isPlaying;
}

/**
 *  启动/结束加载视图
 */
- (void)startActivityLoading
{
    [self.playerView.indicatorView startAnimating];
}

- (void)stopActivityLoading
{
    [self.playerView.indicatorView stopAnimating];
}





- (void)pulledVideoStatus:(NSTimer *)timer
{
    if (self.currentVideoItemDuration > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshCurrentPlayProgress];
        });
    }
}

- (void)refreshCurrentPlayProgress
{
    CGFloat currentTime = [self currentVideoPlayPosition]/1000.f;
    CGFloat videoDur = self.currentVideoItemDuration/1000.f;
    //    NSLog(@"-------->_<%f",videoDur);
    
    NSString *nowTime = [DurationFormat durationTextForDuration:currentTime];
    NSString *videoTime = [DurationFormat durationTextForDuration:videoDur];
    
    self.playerView.timeLabel.text = [NSString stringWithFormat:@"%@/%@",nowTime, videoTime];
    //    NSLog(@"%@",self.playerView.timeLabel.text);
    
    if (!self.videoProgressSliderOnTouched) {
        if (videoDur > 0) {
            self.playerView.progressSlider.value = currentTime/videoDur;
        } else {
            self.playerView.progressSlider.value = 0;
        }
    }
}

- (CGFloat)currentVideoPlayPosition
{
    //    NSLog(@"getCurrentPosition===%ld",[mplayer getCurrentPosition]);
    return [mplayer getCurrentPosition];
}

- (void)resetPlayControlView
{
    self.playerView.pauseButton.hidden = NO;
    self.playerView.playButton.hidden = YES;
    [self.playerView.progressSlider setValue:0.f];
    [self.playerView.timeLabel setText:[DurationFormat durationTextForDuration:0]];
    //[_playControlV.remainTimeLabel setText:[DurationFormat durationTextForDuration:0]];
}

- (void)didSetFullScreenCanvas
{
    [mplayer setVideoFillMode:VMVideoFillModeStretch];
}

- (void)didSet100PercentCanvas
{
    [mplayer setVideoFillMode:VMVideoFillMode100];
}

- (void)seekToPosition:(CGFloat)position
{
    [mplayer seekTo:position];
    
}

//屏幕旋转
//支持旋转的方向$(PROJECT_DIR)/Page
//一开始的屏幕旋转方向$(PROJECT_DIR)
//支持旋转的方向
//一开始的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    NSLog(@"11222111111");
    
    return UIInterfaceOrientationMaskLandscapeLeft;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //    NSLog(@"11111111");
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0 animations:^{
        if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            _playerView.frame = CGRectMake(0, 0, weakself.view.frame.size.height, weakself.view.frame.size.width);
        }else{
            _playerView.frame = CGRectMake(0, 0, weakself.view.frame.size.height, kPlayerH);
        }
    } completion:^(BOOL finished){
        
    }];
}

//恢复或改变transForm
-(void)restoreOrChangeTransForm:(BOOL)restore{
    CGAffineTransform oriTransform=CGAffineTransformIdentity;
    CGAffineTransform topTransform=CGAffineTransformMakeTranslation(0,-self.playerView.topBar.bounds.size.height);
    CGAffineTransform footTransform=CGAffineTransformMakeTranslation(0,self.playerView.bottomBar.bounds.size.height);
    
    if (restore==YES) {
        self.playerView.topBar.transform=oriTransform;
        //self.playerView.backButton.transform=oriTransform;
        //_titleLabel.transform=oriTransform;
        
        self.playerView.bottomBar.transform=oriTransform;
        self.playerView.playButton.transform=oriTransform;
        self.playerView.fullScreenButton.transform=oriTransform;
        //self.playerView.progressSlider.transform=oriTransform;
        self.playerView.progressSlider.transform=oriTransform;
        self.playerView.timeLabel.transform=oriTransform;
    }
    else{
        self.playerView.topBar.transform=topTransform;
        //self.playerView.backButton.transform=topTransform;
        //_titleLabel.transform=topTransform;
        
        self.playerView.bottomBar.transform=footTransform;
        self.playerView.playButton.transform=footTransform;
        self.playerView.fullScreenButton.transform=footTransform;
        //_progressView.transform=footTransform;
        self.playerView.progressSlider.transform=footTransform;
        self.playerView.timeLabel.transform=footTransform;
    }
}

//恢复或改变frame
-(void)restoreOrChangeFrame:(BOOL)restoreFrame{
    if (restoreFrame==YES) {
        //self.playerView.topBar.frame=CGRectMake(0,0,_initFrame.size.width,CDPTOPHEIGHT(NO));
        //self.playerView.bottomBar.frame=CGRectMake(0,_initFrame.size.height-CDPFOOTHEIGHT,_initFrame.size.width,CDPFOOTHEIGHT);
        
        //self.playerView.backButton.frame=CGRectMake(5,self.playerView.topBar.frame.origin.y+CDPTOPHEIGHT(NO)/2-CDPButtonHeight/2,CDPButtonWidth,CDPButtonHeight);
        //_titleLabel.frame=CGRectMake(CGRectGetMaxY(self.playerView.backButton.frame),self.playerView.topBar.frame.origin.y,self.playerView.topBar.frame.size.width-CGRectGetMaxY(self.playerView.backButton.frame)-5,CDPTOPHEIGHT(NO));
    }
    else{
        self.playerView.topBar.frame=CGRectMake(0,0,self.originFrame.size.width,CDPTOPHEIGHT(YES));
        self.playerView.bottomBar.frame=CGRectMake(0,self.originFrame.size.height-CDPFOOTHEIGHT,self.originFrame.size.width,CDPFOOTHEIGHT);
        
        //self.playerView.backButton.frame=CGRectMake(5,self.playerView.topBar.frame.origin.y+CDPTOPHEIGHT(NO)/2-CDPButtonHeight/2+20,CDPButtonWidth,CDPButtonHeight);
        //_titleLabel.frame=CGRectMake(CGRectGetMaxY(self.playerView.backButton.frame),self.playerView.topBar.frame.origin.y+20,self.playerView.topBar.frame.size.width-CGRectGetMaxY(self.playerView.backButton.frame)-5,CDPTOPHEIGHT(NO));
    }
    //_bufferView.frame=CGRectMake(self.bounds.size.width/2-60,self.bounds.size.height/2-30,120,60);
    //_activityView.frame=CGRectMake(_bufferView.frame.origin.x+41,_bufferView.frame.origin.y+1,38,38);
    //_bufferLabel.frame=CGRectMake(_bufferView.frame.origin.x,CGRectGetMaxY(_activityView.frame),120,20);
    
    self.playerView.playButton.frame=CGRectMake(5,self.playerView.bottomBar.frame.origin.y+CDPFOOTHEIGHT/2-CDPButtonHeight/2,CDPButtonWidth,CDPButtonHeight);
    //_switchButton.frame=CGRectMake(self.playerView.bottomBar.frame.size.width-35,self.playerView.bottomBar.frame.origin.y+CDPFOOTHEIGHT/2-CDPButtonHeight/2,CDPButtonWidth,CDPButtonHeight);
    //_timeLabel.frame=CGRectMake(_switchButton.frame.origin.x-80,self.playerView.bottomBar.frame.origin.y,80,CDPFOOTHEIGHT);
    //_progressView.frame=CGRectMake(CGRectGetMaxX(_playButton.frame),self.playerView.bottomBar.frame.origin.y+CDPFOOTHEIGHT/2,CGRectGetMinX(_timeLabel.frame)-CGRectGetMaxX(_playButton.frame),2);
    //_slider.frame=CGRectMake(_progressView.frame.origin.x-2,_progressView.frame.origin.y-14,_progressView.bounds.size.width+2,30);
}




#pragma mark - 滑动调整音量大小
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(event.allTouches.count == 1){
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self.view];
        //        float dx = point.x - startPoint.x;
        float dy = point.y - _startPoint.y;
        int index = (int)dy;
        if(index>0){
            if(index%5==0){//每10个像素声音减一格
                //                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>0.1){
                    _systemVolume = _systemVolume-0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{
            if(index%5==0){//每10个像素声音增加一格
                //                NSLog(@"+x ==%d",index);
                //                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>=0 && _systemVolume<1){
                    _systemVolume = _systemVolume+0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        //亮度调节
        //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
    }
}



/**
 *  设置不可以左右滑动的ScrollView
 */
- (void)setupScrollView{
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kPlayerY + kPlayerH + kButton_H, kView_W, kAddViewX)];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsVerticalScrollIndicator = NO;
    //方向锁
    _scroll.directionalLockEnabled = YES;
    //取消自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scroll.scrollEnabled = NO;
    _scroll.contentSize = CGSizeMake(kView_W * 3,kAddViewX);
    
    [self.view addSubview:_scroll];
}

/**
 *  设置控制的每一个子控制器
 */
- (void)setupChildViewControll{
    self.first = [[IntroduceViewController alloc]init];
    self.second = [[DirectionViewController alloc]init];
    self.four = [[NotesViewController alloc] init];
    self.first = [[UIStoryboard storyboardWithName:@"Player" bundle:nil]instantiateViewControllerWithIdentifier:@"IntroduceViewController"];
    self.second = [[UIStoryboard storyboardWithName:@"Player" bundle:nil]instantiateViewControllerWithIdentifier:@"DirectionViewController"];
    
    self.four = [[UIStoryboard storyboardWithName:@"Player" bundle:nil]instantiateViewControllerWithIdentifier:@"NotesViewController"];
    
    //指定该控制器为其子控制器
    [self addChildViewController:_first];
    [self addChildViewController:_second];
    [self addChildViewController:_four];
    
    //将视图加入ScrollView上
    [_scroll addSubview:_first.view];
    [_scroll addSubview:_second.view];
    [_scroll addSubview:_four.view];
    
    //设置两个控制器的尺寸
    //    _four.view.frame = CGRectMake(kView_W * 3, 0, kView_W, kView_H - CGRectGetMinY(self.pageLine.frame));
    _four.view.frame = CGRectMake(kView_W * 2, 0, kView_W, kAddViewX);
    _second.view.frame = CGRectMake(kView_W, 0, kView_W, kAddViewX);
    _first.view.frame = CGRectMake(0, 0, kView_W, kAddViewX);
    
}
/**
 *  设置分页按钮
 */
- (void)setupPageButton{
    //button的index值应当从0开始
    UIButton * btn = [self setupButtonWithTitle:self.titleArr[0] imageName:self.imageArr[0] Index:0];
    self.selectBtn = btn;
    //    [self.btn setBackgroundColor:[UIColor whiteColor]];
    [self setupButtonWithTitle:self.titleArr[1] imageName:self.imageArr[1] Index:1];
    [self setupButtonWithTitle:self.titleArr[2] imageName:self.imageArr[2] Index:2];
    [self setupButtonWithTitle:self.titleArr[3] imageName:self.imageArr[2] Index:3];
}


- (UIButton *)setupButtonWithTitle:(NSString *)title imageName:(NSString *)imageName Index:(NSInteger)index{
    CGFloat y = kPlayerH + kPlayerY;
    CGFloat w = (kView_W - kMrg * 3)/kPageCount;
    CGFloat h = kButton_H;
    CGFloat x = kMrg + index * w;
    
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    //[btn setTitle:title forState:(UIControlStateNormal)];
    btn.frame = CGRectMake(x, y, w, h);
    [btn setBackgroundColor:[UIColor whiteColor]];
    //[btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.masksToBounds = YES;
    [btn addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(btn);
        make.top.mas_equalTo(btn.mas_top).mas_equalTo(5);
        make.bottom.mas_equalTo(btn.mas_bottom).mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [btn addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = title;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btn);
        make.top.mas_equalTo(imageView.mas_bottom).mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(60, 21));
    }];
    
    btn.tag = index + kTag;
    
    [btn addTarget:self action:@selector(pageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return btn;
}

- (void)pageClick:(UIButton *)btn{
    
    if (btn.tag == 103) {
        CommentViewController *three = [[CommentViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:three];
        navi = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"CommentNavi"];
        //        [self.navigationController pushViewController:navi animated:YES];
        [self presentViewController:navi animated:YES completion:nil];
        
    }
    
    self.currentPages = btn.tag - kTag;
    [self gotoCurrentPage];
}
/**
 *  设置选中button的样式
 */
- (void)setupSelectBtn{
    UIButton *btn = [self.view viewWithTag:self.currentPages + kTag];
    if ([self.selectBtn isEqual:btn]) {
        return;
    }
    
    self.selectBtn = btn;
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    //self.pageLine.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame));
}
/**
 *  进入当前的选定页面
 */
- (void)gotoCurrentPage{
    CGRect frame;
    frame.origin.x = self.scroll.frame.size.width * self.currentPages;
    frame.origin.y = 0;
    frame.size = _scroll.frame.size;
    [_scroll scrollRectToVisible:frame animated:YES];
}


#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _scroll.frame.size.width;
    self.currentPages = floor((_scroll.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tempArrA
{
    if (!_tempArrA) {
        _tempArrA = [[NSMutableArray alloc] init];
    }
    return _tempArrA;
}
- (NSMutableArray *)tempArrB
{
    if (!_tempArrB) {
        _tempArrB = [[NSMutableArray alloc] init];
    }
    return _tempArrB;
}
- (NSArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = @[@"contents_01.png", @"intro_02.png",@"notes_04.png", @"comment_03.png"];
    }
    return _imageArr;
}
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"简介", @"目录", @"笔记", @"评论"];
    }
    return _titleArr;
}
- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [[NSMutableDictionary alloc] init];
    }
    return _dataDic;
}
-(UIScrollView *)scroll
{
    if(_scroll == nil)
    {
        _scroll =[[UIScrollView alloc] init];
    }
    return _scroll;
}


@end
