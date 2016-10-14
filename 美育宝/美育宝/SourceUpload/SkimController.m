//
//  SkimController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "SkimController.h"
#import "UIImageView+WebCache.h"
#import "PreviewImageView.h"
#import "MYToolsModel.h"

@interface SkimController ()
{
    NSString *_photoStr;
    NSString *_title;
    NSString *_identifier;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;

@end

@implementation SkimController

- (instancetype)initWithHeaderPicture:(NSString *)imageStr title:(NSString *)title identifier:(NSString *)identy
{
    self = [super init];
    if (self) {
        _photoStr = imageStr;
        _title    = title;
        _identifier = identy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"作品浏览";
    [self setUpHeaderImages];
}

-(void)setUpHeaderImages
{
    if (!_title) {
        [self getData];
    }
    
        self.titleLabel.text = _title;
    //
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_photoStr] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    
    self.headerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self.headerImageView addGestureRecognizer:tapGR];
}

- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [self.headerImageView convertRect:self.headerImageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:self.headerImageView.image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
}

-(void)getData
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSDictionary *dataDict = [tools getDictArrayFromPlist:@"SkitData.plist"];
    _title = [dataDict objectForKey:@"fjmc"];
    _photoStr = [dataDict objectForKey:@"photostr"];
    _identifier = [dataDict objectForKey:@"mxdm"];
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
