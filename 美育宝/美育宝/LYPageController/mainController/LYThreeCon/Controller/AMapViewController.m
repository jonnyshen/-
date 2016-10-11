//
//  AMapViewController.m
//  美育宝
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "AMapViewController.h"


#define LocationTimeout 3  //   定位超时时间，可修改，最小2s
#define ReGeocodeTimeout 3 //   逆地理请求超时时间，可修改，最小2s

@interface AMapViewController ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, strong) UILabel *displayLabel;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateNow;

@end

@implementation AMapViewController


#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
}

- (void)cleanUpAction
{
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        NSLog(@"%f===%f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        self.coordinateNow = userLocation.coordinate;
        /*  大头针
         MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
         pointAnnotation.coordinate = userLocation.coordinate;
         pointAnnotation.title = @"方恒国际";
         pointAnnotation.subtitle = @"阜通东大街6号";
         
         [self.mapView addAnnotation:pointAnnotation];
         */
    }
}

- (void)ShareLocationBtn:(UIButton *)shareLocation
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享当前位置" message:@"默认分享对象：陈老师" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%f-----%f",self.coordinateNow.latitude,self.coordinateNow.longitude);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)locAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}


#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak AMapViewController *wSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (location)
        {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            AMapViewController *sSelf = wSelf;
            [sSelf addAnnotationToMapView:annotation];
        }
    };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)initToolBar
{
    /*
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UIBarButtonItem *reGeocodeItem = [[UIBarButtonItem alloc] initWithTitle:@"带逆地理定位"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(reGeocodeAction)];
    
    UIBarButtonItem *locItem = [[UIBarButtonItem alloc] initWithTitle:@"不带逆地理定位"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(locAction)];
    
    ///self.toolbarItems = [NSArray arrayWithObjects:flexble, reGeocodeItem, flexble, flexble, nil];
    */
    
    UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [self.mapView addSubview:toolbarView];
    toolbarView.alpha = 0.6f;
    toolbarView.backgroundColor = [UIColor whiteColor];
    
    UIButton *reGeocodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height - 49, 70, 49)];
    reGeocodeBtn.backgroundColor = [UIColor redColor];
    [reGeocodeBtn addTarget:self action:@selector(reGeocodeAction) forControlEvents:UIControlEventTouchUpInside];
    [reGeocodeBtn setTitle:@"定位" forState:UIControlStateNormal];
    [self.mapView addSubview:reGeocodeBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 49, 70, 49)];
    shareBtn.backgroundColor = [UIColor greenColor];
    [shareBtn addTarget:self action:@selector(ShareLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.mapView addSubview:shareBtn];
    
    UIButton *helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 35, self.view.frame.size.height - 49 - 35, 70, 70)];
    helpBtn.backgroundColor = [UIColor redColor];
    [helpBtn setTitle:@"SOS" forState:UIControlStateNormal];
//    [helpBtn setFont:[UIFont systemFontOfSize:30]];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [helpBtn setTintColor:[UIColor blackColor]];
    helpBtn.layer.masksToBounds = YES;
    helpBtn.layer.cornerRadius = 30;
    [helpBtn addTarget:self action:@selector(telephoneCall) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:helpBtn];
    
}

- (void)telephoneCall
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://18813759575"]];
}

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clean"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cleanUpAction)];
}

- (void)returnAction
{
    [self cleanUpAction];
     
    self.completionBlock = nil;
    
    [super returnAction];
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
//    self.navigationController.toolbar.translucent   = YES;
//    [self.navigationController setToolbarHidden:NO animated:animated];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MAMapServices sharedServices].apiKey = @"4dd35cce630c4098a4fd36e66b15f494";
    [AMapLocationServices sharedServices].apiKey = @"4dd35cce630c4098a4fd36e66b15f494";
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = self.view.bounds;
    
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self initToolBar];
    
    [self initNavigationBar];
    
    [self initCompleteBlock];
    
    [self configLocationManager];
   
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
