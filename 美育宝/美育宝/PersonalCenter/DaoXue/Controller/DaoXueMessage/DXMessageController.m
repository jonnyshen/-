//
//  DXMessageController.m
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DXMessageController.h"
#import "AFNetworking.h"
#import "DXMessageViewCell.h"
#import "DXPictureViewCell.h"
#import "MessageModel.h"
#import "PictureSourceModel.h"
#import "MYToolsModel.h"
#import "GGBaseCell.h"
#import "PreviewImageView.h"
#import "LYPlayerViewController.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface DXMessageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *_dxid;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (nonatomic, strong) NSMutableArray *pictureArr;


@end

@implementation DXMessageController

- (NSMutableArray *)messageArr
{
    if (!_messageArr) {
        _messageArr = [[NSMutableArray alloc] init];
    }
    return _messageArr;
}
- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc] init];
    }
    return _pictureArr;
}

- (instancetype)initWithDXID:(NSString *)dxid
{
    self = [super init];
    if (self) {
        _dxid = dxid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self httpRequest];
    
    [self setUpCollectionView];
    
    
    
    
}

- (void)setUpCollectionView
{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.flowLayout = layout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:self.flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DXMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"DXMessageViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DXPictureViewCell" bundle:nil] forCellWithReuseIdentifier:@"DXPictureViewCell"];
}


- (void)httpRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *DXMessage_Request_RUL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getdxinfo&dxid=%@",_dxid];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:DXMessage_Request_RUL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            MYToolsModel *tools = [MYToolsModel new];
            [tools saveToPlistWithPlistName:@"DXMessagePicture.plist" andData:responseObject[@"imgurl"]];
            
            
            MessageModel *message = [[MessageModel alloc] init];
            
                message.titleMessage = responseObject[@"data"][@"DXBT"];
                message.messageDetail  = responseObject[@"data"][@"DXMS"];
                [self.messageArr addObject:message];
            
            NSArray *datazy = responseObject[@"datazy"];
            
            if (!datazy) {
                
            } else {
                PictureSourceModel *pictureModel = [[PictureSourceModel alloc] init];
                for (NSDictionary *pict in responseObject[@"datazy"]) {
                    pictureModel.pictureString = pict[@"IMGPATH"];
                    pictureModel.sourceType    = pict[@"ZYLX"];
                    pictureModel.sourcePath    = pict[@"ZYLJ"];
                    [self.pictureArr addObject:pictureModel];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
        
        
        
    });
}



#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.pictureArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = @"DXMessageViewCell";
    } else {
        cellID = @"DXPictureViewCell";
    }
    
    GGBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0 && self.messageArr.count > 0) {
        cell.userInteractionEnabled = NO;
        MessageModel *message = self.messageArr[indexPath.row];
        [cell setCellModel:message];
    } else if(indexPath.section == 1 && self.pictureArr.count > 0){
        PictureSourceModel *picture = self.pictureArr[indexPath.row];
        [cell setCellModel:picture];
    }
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         return CGSizeMake(ScreenWidth, ScreenWidth/3);
    }
    return CGSizeMake(ScreenWidth/3 - 10, ScreenWidth/3 - 10);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(ScreenWidth/5, 10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    PictureSourceModel *picture = self.pictureArr[indexPath.row];
    
    NSString *videoUrl;
    
    
    if ([picture.sourceType isEqualToString:@".jpg"] || [picture.sourceType isEqualToString:@".png"]) {
        
        if (picture.pictureString.length > 6) {
            [self checkImageWithEnlarge:[self pieceStringTogether:picture.pictureString]];
        }
        
    } else {
        
        if (picture.pictureString.length > 6 ) {
            videoUrl = [self pieceStringTogether:picture.pictureString];
            LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoURL:videoUrl andComeFromWhichVC:@"VIDEOURL"];
            [self presentViewController:player animated:YES completion:nil];
        }
        
        
    }
    
}

- (void)checkImageWithEnlarge:(NSString *)imageUrl
{
    DXPictureViewCell *workcell = [[DXPictureViewCell alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response;
    NSError *error;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    UIImage *image = [UIImage imageWithData:imageData];
    
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [workcell.pictureView convertRect:workcell.pictureView.bounds toView:windows];
    [PreviewImageView showPreviewImage:image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
}


- (NSString *)pieceStringTogether:(NSString *)originalStr
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"DXMessagePicture.plist" andNumber:0];
    
    NSString *cutIndexStr = [originalStr substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, originalStr];
    
    return imageUrl;
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
