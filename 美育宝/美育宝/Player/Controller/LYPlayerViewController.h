//
//  LYPlayerViewController.h
//  Page Demo
#import <UIKit/UIKit.h>

@interface LYPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *joinClass;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


- (instancetype)initWithVideoId:(NSString *)vid andComeFromWhichVC:(NSString *)vc;
- (instancetype)initWithVideoURL:(NSString *)videoURL andComeFromWhichVC:(NSString *)vc;
- (instancetype)initWithVideoURL:(NSString *)videoURL videoID:(NSString *)vid andComeFromWhichVC:(NSString *)vc;

// 播放到某个进度, 单位为秒
- (void)seekToPosition:(CGFloat)position;

/**
 *  设置屏幕模式
 */
- (void)didSetFullScreenCanvas;
- (void)didSet100PercentCanvas;


// 当前视频的时长，单位是毫秒
//- (CGFloat)currentVideoDuration;
// 当前视频播放位置，单位是毫秒
- (CGFloat)currentVideoPlayPosition;


//- (void)showInWindow;


@end
