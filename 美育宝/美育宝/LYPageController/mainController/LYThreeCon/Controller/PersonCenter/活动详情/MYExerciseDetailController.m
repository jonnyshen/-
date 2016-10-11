//
//  MYExerciseDetailController.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYExerciseDetailController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "ImageModel.h"
#import "CampDetailModel.h"
#import "ActivityImageModel.h"
#import "PartyPhotoTableCell.h"
#import "ExerciseDetailCell.h"
#import "SharePhotoCell.h"
#import "FirstTableViewCellModal.h"

#import "MYToolsModel.h"
#import "EXDetail.h"

#define ViewFrame self.view.frame

@interface MYExerciseDetailController ()<UIWebViewDelegate>
{
    NSString *_partyID;
    NSString *_photoPath;
    NSString *_imageStr;
    NSString *_linker;
}
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (nonatomic, strong) NSMutableArray *tempHeadImage;
@property (nonatomic, strong) NSMutableArray *tempDetail;
@property (nonatomic, strong) NSMutableArray *tempPicture;

@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation MYExerciseDetailController

- (instancetype)initWithExerciseID:(NSString *)code andhtmlLink:(NSString *)link
{
    if (self = [super init]) {
        _partyID = code;
        _linker  = link;
    }
    return self;
}



- (NSMutableArray *)tempHeadImage
{
    if (!_tempHeadImage) {
        _tempHeadImage = [NSMutableArray array];
    }
    return _tempHeadImage;
}
- (NSMutableArray *)tempDetail
{
    if (!_tempDetail) {
        _tempDetail = [[NSMutableArray alloc] init];
    }
    return _tempDetail;
}
- (NSMutableArray *)tempPicture
{
    if (!_tempPicture) {
        _tempPicture = [[NSMutableArray alloc] init];
    }
    return _tempPicture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"活动详情";
//    [self httpRequest];
    
//    [self initSubView];
    
    NSString *partyHtml = [NSString stringWithFormat:@"%@%@",_linker,_partyID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:partyHtml] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    
    UIWebView *partyWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
    partyWeb.delegate = self;
    partyWeb.scrollView.bounces = NO;
    [self.view addSubview:partyWeb];
    
//    partyWeb.scalesPageToFit = YES;
    [partyWeb loadRequest:request];
    
  
    
   
}





- (void)httpRequest
{

    NSLog(@"-----id----%@",_partyID);
    NSString *partyURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=gethdinfo&hdid=%@",_partyID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:partyURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        _photoPath = [responseObject objectForKey:@"filespath"];
        MYToolsModel *tools = [MYToolsModel new];
        [tools saveToPlistWithPlistName:@"ImageEX.plist" andData:_photoPath];
        
        NSDictionary *param = responseObject[@"data"];
        CampDetailModel *detail = [CampDetailModel new];
            detail.campName     = param[@"HDMC"];
            detail.startTime    = param[@"KSSJ"];
            detail.endTime      = param[@"JSSJ"];
            detail.campDetail   = param[@"HDMS"];
            detail.member       = param[@"HDCYR"];
            detail.gatherPlace  = param[@"JHDD"];
            detail.campPlace    = param[@"HDDD"];
        [self.tempDetail addObject:detail];
        
        ImageModel *image       = [ImageModel new];
            image.imagePath = param[@"HDZP"];
        image.pointX = 0;
        image.pointY = 0;
        image.rectWidth = self.view.bounds.size.width;
        image.rectHeight = self.view.bounds.size.height;
        [self.tempHeadImage addObject:image];
        
        NSMutableArray *imageArr = [NSMutableArray array];
        NSString *imageString = nil;
        ActivityImageModel *active = [ActivityImageModel new];
        for (NSDictionary *dict in responseObject[@"datazp"]) {
            
            imageString = dict[@"WJLJ"];
            [imageArr addObject:imageString];
        }
        active.photoArr = imageArr;
        [self.tempPicture addObject:active];
       
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

- (void)initSubView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    

    [self.tableView registerNib:[UINib nibWithNibName:@"PartyPhotoTableCell" bundle:nil] forCellReuseIdentifier:@"PartyPhotoTableCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"ExerciseDetailCell" bundle:nil] forCellReuseIdentifier:@"ExerciseDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SharePhotoCell" bundle:nil] forCellReuseIdentifier:@"SharePhotoCell"];

    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = @"PartyPhotoTableCell";
    } else if (indexPath.section == 1) {
        cellID = @"ExerciseDetailCell";
    } else {
        cellID = @"SharePhotoCell";
    }
    
    FirstTableViewCellModal *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    

    
    if (indexPath.section == 0) {
        if (self.tempHeadImage.count > 0) {
            ImageModel *image = self.tempHeadImage[indexPath.row];
//            ImageModel *image = [ImageModel new];
            [cell setTableViewCellModel:image];
        }
        
    } else if (indexPath.section == 1) {
        if (self.tempDetail.count > 0) {
            CampDetailModel *camp = self.tempDetail[indexPath.row];
//            CampDetailModel *camp = [CampDetailModel new];
            [cell setTableViewCellModel:camp];

        }
        
    } else {
        if (self.tempPicture.count > 0) {
            ActivityImageModel *active = self.tempPicture[indexPath.row];
            [cell setTableViewCellModel:active];

        }
        
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1) {
        return 300;
    }
    return 400;
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
