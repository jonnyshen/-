//
//  AMapViewController.h
//  美育宝
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BaseMapViewController.h"

@interface AMapViewController : BaseMapViewController
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIView *locationBtn;


//@property (strong, nonatomic) MAMapView *mapView;

@end
