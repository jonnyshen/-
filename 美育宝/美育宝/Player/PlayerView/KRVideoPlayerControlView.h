//
//  KRVideoPlayerControlView.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRVideoPlayerControlView : UIView

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

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
