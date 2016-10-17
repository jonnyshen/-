//
//  KRVideoPlayerControlView.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRVideoPlayerControlView : UIView

@property (nonatomic, strong, readonly) UIView *topBar;//头部视图
@property (nonatomic, strong, readonly) UIView *bottomBar;//底部视图
@property (nonatomic, strong, readonly) UIButton *playButton;//播放
@property (nonatomic, strong, readonly) UIButton *pauseButton;//暂停
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;//全屏
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;//小屏
@property (nonatomic, strong, readonly) UISlider *progressSlider;//播放进度条
@property (nonatomic, strong, readonly) UIButton *closeButton;//关闭 退出播放页面
@property (nonatomic, strong, readonly) UILabel *timeLabel;//视频时间
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;//视频名称

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

// 播放到某个进度, 单位为秒
//- (void)seekToPosition:(CGFloat)position;

/**
 *  设置屏幕模式
 */
//- (void)didSetFullScreenCanvas;
//- (void)didSet100PercentCanvas;


// 当前视频的时长，单位是毫秒
//- (CGFloat)currentVideoDuration;
// 当前视频播放位置，单位是毫秒
//- (CGFloat)currentVideoPlayPosition;

@end
