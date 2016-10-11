//
//  ExcelentWorksController.m
//  美育宝
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ExcelentWorksController.h"
#import "MYWorks.h"
#import "MYShowWorksCollectionCell.h"
#import "MYShowWorksReusableView.h"
#import "MYToolsModel.h"
#import "LYPlayerViewController.h"
#import "PreviewImageView.h"
#import "AFNetworking.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kCollectionViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49)
#define kWORKSURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=10&pageindex=1&xh=&bh=&isgood=1"
@interface ExcelentWorksController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger photoCount;
    NSInteger sumcount;
}
@property (nonatomic, strong) NSMutableArray *worksArr;
@property (nonatomic, strong) NSMutableArray *worksImageArr;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation ExcelentWorksController
- (NSMutableArray *)worksArr
{
    if (!_worksArr) {
        _worksArr = [[NSMutableArray alloc] init];
    }
    return _worksArr;
}

- (NSMutableArray *)worksImageArr
{
    if (!_worksImageArr) {
        _worksImageArr = [[NSMutableArray alloc] init];
    }
    return _worksImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpTableView];
    
    [self getImageDataHttpRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView
{
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.flowLayout = layout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:kCollectionViewFrame collectionViewLayout:self.flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYShowWorksCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MYShowWorksCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYShowWorksReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MYShowWorksReusableView"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.worksArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.worksArr.count > 0) {
        MYWorks *works = self.worksArr[section];
        
        
        NSInteger count = works.imageStr.count;
        
        return count;
//    }
//    return 0;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYShowWorksCollectionCell";
    //    GGBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    MYShowWorksCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.worksArr.count > 0) {

        MYWorks *works = self.worksArr[indexPath.section];
        
        
        for (NSDictionary *dic in works.imageStr) {
            MYWorkImage *imageModel = [MYWorkImage workModelWithDictionary:dic];
            
            cell.obj = imageModel;
        }
        
        
        
        
        
        
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/3 - 10, ScreenWidth/3 - 10);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MYShowWorksReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MYShowWorksReusableView" forIndexPath:indexPath];
    if (self.worksArr.count > 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
          
            MYWorks *reusableWorks = self.worksArr[indexPath.section];
            NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
            [detailFormatter setLocale:[NSLocale currentLocale]];
            [detailFormatter setDateFormat:@"yyyyMMdd"];
            NSDate *date = [detailFormatter dateFromString:reusableWorks.timeLb];
            
            NSString *time = [NSString stringWithFormat:@"%@", date];
            
            NSString *pieceTime = [NSString stringWithFormat:@"作品上传日期：%@",[time substringWithRange:NSMakeRange(0, 10)]];
            reusableView.times.text = pieceTime;
            
            
            
            
        }
    }
    return reusableView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(ScreenWidth/5, 50);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.worksArr.count == 0) {
        return;
    }
    MYWorks *works = self.worksArr[indexPath.section];
    NSString *imageString = nil;
    NSString *sourceType  = nil;
    //    for (NSDictionary *dic in works.imageStr) {
    //        imageString = dic[@"ZYLJ"];
    //        sourceType   = dic[@"ZYLX"];
    //    }
    NSDictionary *dic = works.imageStr[indexPath.row];
    imageString = dic[@"ZYLJ"];
    sourceType   = dic[@"ZYLX"];
    NSString *videoString = dic[@"SWF"];
    
    if ([sourceType isEqualToString:@".jpg"] || [sourceType isEqualToString:@".png"]) {
        
        
        [self checkImageWithEnlarge:[self pieceStringTogether:imageString]];
        
    } else {
        
        NSString *videoUrl;
        if ([videoString isEqualToString:@""]) {
            videoUrl = [self pieceStringTogether:imageString];
        } else {
            videoUrl = [self pieceStringTogether:videoString];
        }
        
        LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoURL:videoUrl andComeFromWhichVC:@"VIDEOURL"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
        
    }
    
    
    
}

- (NSString *)pieceStringTogether:(NSString *)originalStr
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"Works.plist" andNumber:0];
    
    NSString *cutIndexStr = [originalStr substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, originalStr];
    
    return imageUrl;
}

- (void)checkImageWithEnlarge:(NSString *)imageUrl
{
    MYShowWorksCollectionCell *workcell = [[MYShowWorksCollectionCell alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSURLResponse *response;
    NSError *error;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    UIImage *image = [UIImage imageWithData:imageData];
    
    
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [workcell.imageView convertRect:workcell.imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
}








- (void)getImageDataHttpRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
       
        
        
        
        NSString *showPhotoUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=1000&pageindex=1&xh=&bh=&isgood=1"];

        [manager POST:showPhotoUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"aaData"] isKindOfClass:[NSNull class]]) {
                return;
            }
            
            NSString *imageStr = [responseObject objectForKey:@"imgurl"];
            [tools saveToPlistWithPlistName:@"Works.plist" andData:imageStr];
            
            sumcount = [[responseObject objectForKey:@"sumcount"] integerValue];
            
            self.worksArr = [NSMutableArray array];
            for (NSDictionary *params in responseObject[@"aaData"]) {
                MYWorks *works = [[MYWorks alloc] init];
                
                works.timeLb = params[@"dayName"];
                
                //每一个日期的作品有多少张图片
                NSArray *image = params[@"data"];
                photoCount = image.count;
                works.imageStr = image;
                
                [self.worksArr addObject:works];
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
                        
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
        
        
        
    });
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
