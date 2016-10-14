//
//  TeachClassController.m
//  美育宝
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "TeachClassController.h"
#import "MYWorks.h"
#import "MYShowWorksCollectionCell.h"
#import "MYShowWorksReusableView.h"
#import "MYToolsModel.h"
#import "LYPlayerViewController.h"
#import "PreviewImageView.h"
#import "AFNetworking.h"
#import "LrdSuperMenu.h"
#import "FormValidator.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kCollectionViewFrame CGRectMake(0, 40+64, self.view.frame.size.width, self.view.frame.size.height-49-40-64)
#define kWORKSURL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=10&pageindex=1&xh=&bh=&isgood=0"

@interface TeachClassController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,LrdSuperMenuDelegate,LrdSuperMenuDataSource>
{
    NSInteger photoCount;
    NSInteger sumcount;
}
@property (nonatomic, strong) MYToolsModel *tools;
@property (nonatomic, strong) NSMutableArray *worksArr;
@property (nonatomic, strong) NSMutableArray *worksImageArr;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classifyID;

@property (nonatomic, strong) LrdSuperMenu *menu;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation TeachClassController

- (MYToolsModel *)tools
{
    if (!_tools) {
        _tools = [[MYToolsModel alloc] init];
    }
    return _tools;
}
- (NSMutableArray *)classify
{
    if (!_classify) {
        _classify = [[NSMutableArray alloc] init];
        
        [_classify addObjectsFromArray:[self.tools getArrayFromPlistName:@"TeacherClass.plist" andNumber:0]];
    }
    return _classify;
}

- (NSMutableArray *)classifyID
{
    if (!_classifyID) {
        _classifyID = [[NSMutableArray alloc] init];
        [_classifyID addObjectsFromArray:[self.tools getArrayFromPlistName:@"TeacherClass.plist" andNumber:1]];
    }
    return _classifyID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//
    if (self.classify) {
        _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
        _menu.delegate = self;
        _menu.dataSource = self;
        [self.view addSubview:_menu];
        [_menu selectDeafultIndexPath];
    }
//
    
    [self setUpTableView];
    
    [self getImageDataHttpRequest:self.classifyID.firstObject];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_menu reloadData];
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
    if (self.worksArr.count > 0) {
        MYWorks *works = self.worksArr[section];
        
        
        NSInteger count = works.imageStr.count;
        
        return count;
    }
    return 0;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MYShowWorksCollectionCell";
    //    GGBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    MYShowWorksCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.worksArr.count > 0) {
        
        //        MYWorkImage *works = self.worksImageArr[indexPath.row];
        
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
    MYShowWorksReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MYShowWorksReusableView" forIndexPath:indexPath];
    
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
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        UIImage *image = [UIImage imageWithData:data];
//        UIWindow *windows = [UIApplication sharedApplication].keyWindow;
//        CGRect startRect = [workcell.imageView convertRect:workcell.imageView.bounds toView:windows];
//        [PreviewImageView showPreviewImage:image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
//    }];
//    [dataTask resume];
    
    NSURLResponse *response;
    NSError *error;
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    UIImage *image = [UIImage imageWithData:imageData];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [workcell.imageView convertRect:workcell.imageView.bounds toView:windows];
    [PreviewImageView showPreviewImage:image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
    
    
    
}

- (void)getImageDataHttpRequest:(NSString *)classNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        
        NSString *showPhotoUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=1000&pageindex=1&xh=&bh=%@&isgood=0",classNumber];

        [manager POST:showPhotoUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"aaData"] isKindOfClass:[NSNull class]]) {
                return;
            }
            
            NSString *imageStr = [responseObject objectForKey:@"imgurl"];
            [tools saveToPlistWithPlistName:@"Works.plist" andData:imageStr];
            sumcount = [responseObject[@"sumcount"] integerValue];
            
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
            
            //            [self.collectionView footerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
        
        
        
    });
}

/*
- (NSMutableArray *)classifyData
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *loginCode = [tools sendFileString:@"LoginData.plist" andNumber:0];
    
    NSString *logincodeUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyclass&logincode=%@",loginCode];
    
    
    
    
    NSURL *httpUrl = [NSURL URLWithString:logincodeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无班级数据"];
        return nil;
    }
    
    [self.classifyID removeAllObjects];
    for (NSDictionary *diction in dict[@"data"]) {
        [self.classifyID addObject:diction[@"BH"]];
        [self.classify addObject:diction[@"NJBM"]];
        
    }
    
    
    
    
    
    
    
    
    
 
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:logincodeUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([dict[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"暂无班级数据"];
            return;
        }
        
        for (NSDictionary *params in dict[@"data"]) {
            
            if ([params[@"BJMC"] isKindOfClass:[NSNull class]]) {
                [self.classify addObject:@" "];
            } else {
                [self.classify addObject:params[@"BJMC"]];
            }
            
            
            [self.classifyID addObject:params[@"BJH"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.menu reloadData];
        });
//        [self getGroupChartHttpRequest:0 classid:self.classifyID.firstObject];
    }];
    [dataTask resume];
    
 
    return self.classify;
}*/

#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 1;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    return self.classify.count;
    
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    
     return self.classify[indexPath.row];
    
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    }
    return nil;
}


- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        
        NSLog(@"点击了%ld 项目",indexPath.row);
        if (indexPath.row == 0) {
            
        } else {
            [self getImageDataHttpRequest:self.classifyID[indexPath.row]];
        }
        
    }
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
