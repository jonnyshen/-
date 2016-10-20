//
//  UploadController.m
//  美育宝
#import "UploadController.h"
#import "WorksController.h"
#import "SourceController.h"

@interface UploadController ()

@property (weak, nonatomic) IBOutlet UIButton *worksBtn;
@property (weak, nonatomic) IBOutlet UIButton *sourceBtn;

@end

@implementation UploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传途径";
    
    [self.worksBtn addTarget:self action:@selector(worksBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sourceBtn addTarget:self action:@selector(sourceBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)worksBtnClick
{
    WorksController *works = [[WorksController alloc] init];
    [self.navigationController pushViewController:works animated:YES];
}

- (void)sourceBtnClick
{
    SourceController *source = [[SourceController alloc] init];
    [self.navigationController pushViewController:source animated:YES];
}

@end
