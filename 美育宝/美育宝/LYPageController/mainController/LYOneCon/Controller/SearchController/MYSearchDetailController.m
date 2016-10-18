//
//  MYSearchDetailController.m
//  美育宝
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSearchDetailController.h"
#import "UIScrollView+UzysAnimatedGifLoadMore.h"
#import "MYSearchCell.h"
#import "AFNetworking.h"
#import "SearchModel.h"
#import "MYToolsModel.h"
#import "FormValidator.h"
#import "MYMakeUpCompleteString.h"
#import "LYPlayerViewController.h"
#import "DetailTextViewController.h"

#define kScreen375Scale kScreenWidth/375.0
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface MYSearchDetailController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSString *imagePath;
    NSString *filePath;
}
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *searchArr;


@end

static NSString *showContentCellIdentifier = @"MYSearchCell";


@implementation MYSearchDetailController

- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (instancetype)initWithRequestSearch:(BOOL)isSearch
{
    self = [super init];
    if (self) {
        _isSearch = isSearch;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [self initSubViews];
    [self requestData];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    [addBtn setImage:[UIImage imageNamed:@"gobackBtn"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
}

- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)initSubViews{
    
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.delegate   = self;
    self.contentCollectionView.dataSource = self;
    
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"MYSearchCell" bundle:nil]
             forCellWithReuseIdentifier:showContentCellIdentifier];
    

}



- (void)refreshAddAction{
//    _pageIndex = _contentModelArray.count;
    [self requestData];
}

- (void)requestData
{
    NSString *search_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=searchlist&key=%@&pageindex=1&pagesize=100",_requestType];
//    NSLog(@"%@",search_URL);
    NSString *code_Url = [search_URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@",code_Url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:code_Url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        imagePath = [responseObject objectForKey:@"kc_imgurl"];
        filePath  = [responseObject objectForKey:@"zy_imgurl"];
        NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:imagePath,filePath, nil];
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveDataToPlistWithPlistName:@"SearchImagePath.plist" andData:imageArray];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            [FormValidator showAlertWithStr:@"抱歉，没有搜到任何有关内容"];
            return;
        }
        
        for (NSDictionary *params in responseObject[@"data"]) {
            
            SearchModel *search = [[SearchModel alloc] init];
            search.classId      = params[@"id"];
            search.title        = params[@"bt"];
            search.imageStr     = params[@"imgpath"];
            search.filePath     = params[@"filepath"];
            search.timeStr      = params[@"fbsj"];
            search.source       = params[@"xxlb"];
            [self.searchArr addObject:search];
        }
        [self.contentCollectionView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth, 90 * kScreen375Scale);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MYSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showContentCellIdentifier forIndexPath:indexPath];
    cell.searchCell = self.searchArr[indexPath.row];
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SearchModel *search = self.searchArr[indexPath.row];
    
    if ([search.source isEqualToString:@"资源信息"]) {
        //资源信息
        NSString *conplete_Video_Link = [MYMakeUpCompleteString handleWithHeaderImage:search.filePath headStr:filePath];
        if ([self judgeVideoOrPiture:conplete_Video_Link]) {
//            视频信息
            LYPlayerViewController *playerZY = [[LYPlayerViewController alloc] initWithVideoURL:conplete_Video_Link videoID:search.classId andComeFromWhichVC:@""];
            [self presentViewController:playerZY animated:YES completion:nil];
            NSLog(@"%@",conplete_Video_Link);
        } else {
//            图片信息
            DetailTextViewController *textViewCon = [[DetailTextViewController alloc] initWithImageString:conplete_Video_Link commemtID:search.classId from:@" " title:search.title];
            [self.navigationController pushViewController:textViewCon animated:YES];
        }
        
        
    } else {
        //非资源信息
        NSString *piture_FilePath = [MYMakeUpCompleteString handleWithHeaderImage:search.imageStr headStr:imagePath];
        
        if ([self judgeVideoOrPiture:piture_FilePath]) {
            //            视频信息
            LYPlayerViewController *playerZY = [[LYPlayerViewController alloc] initWithVideoURL:piture_FilePath videoID:search.classId andComeFromWhichVC:@""];
            [self presentViewController:playerZY animated:YES completion:nil];
            
        } else {
            //            图片信息
            DetailTextViewController *textViewCon = [[DetailTextViewController alloc] initWithImageString:piture_FilePath commemtID:search.classId from:@" " title:search.title];
            [self.navigationController pushViewController:textViewCon animated:YES];
        }
        
        
    }
    
    
    
}

- (BOOL)judgeVideoOrPiture:(NSString *)file
{
    NSString *extensionName = file.pathExtension;
    if ([extensionName.lowercaseString isEqualToString:@"flv"] || [extensionName.lowercaseString isEqualToString:@"avi"] || [extensionName.lowercaseString isEqualToString:@"mp4"]) {
        return YES;
    } else {
        return NO;
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
