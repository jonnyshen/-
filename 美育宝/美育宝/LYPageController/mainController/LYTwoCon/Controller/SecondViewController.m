//
//  SecondViewController.m
//  Page Demo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

#import "hotCollectionViewCell.h"
#import "RecommandCollectionViewCell.h"
#import "WritingCollectionViewCell.h"
#import "LYPlayerViewController.h"
#import "GGRecomHeaderView.h"
#import "GGBaseCell.h"
#import "MoreViewController.h"

#import "HotClassModal.h"
#import "ReconmmandModal.h"
#import "WritingModal.h"

#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kFirstSectionMoreBtnTag @"100"
#define kSecondSectionMoreBtnTag @"101"
//首页热门
#define ClassUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getindexinfo"
//推荐
#define kTJClassUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkclist&pagesize=13&pageindex=1&key=&lbid=&type=tj"

//热门
#define kRMClassUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getgkkclist&pagesize=13&pageindex=1&key=&lbid=&type=rm"


@interface SecondViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@property(nonatomic , strong) NSMutableArray  *tempArrA;
@property(nonatomic , strong) NSMutableArray  *tempArrB;
@property(nonatomic , strong) NSMutableArray  *tempArrC;
//@property(nonatomic , strong) NSMutableArray  *tempArrD;
@property(nonatomic , strong) NSArray  *tempArrE;
@property(nonatomic , strong) NSMutableDictionary *dataDic;
@property (nonatomic, assign) NSInteger tag;

@end

@implementation SecondViewController

#pragma mark 懒加载存放数据的数组
-(NSMutableArray *)tempArrA{
    if (_tempArrA == nil) {
        _tempArrA = [[NSMutableArray alloc]init];
    }
    return _tempArrA;
}
-(NSMutableArray *)tempArrB{
    if (_tempArrB == nil) {
        _tempArrB = [[NSMutableArray alloc]init];
    }
    return _tempArrB;
}
-(NSMutableArray *)tempArrC{
    if (_tempArrC == nil) {
        _tempArrC = [[NSMutableArray alloc]init];
    }
    return _tempArrC;
}
//-(NSMutableArray *)tempArrD{
//    if (_tempArrD == nil) {
//        _tempArrD = [[NSMutableArray alloc]init];
//    }
//    return _tempArrD;
//}
-(NSArray *)tempArrE{
    if (_tempArrE == nil) {
        _tempArrE = @[@"热门课程", @"热门推荐", @"名家推荐", @"小学作文／议论文", @"小学作文／议论文", @"nihenhao", @"youbadbad"];
    }
    return _tempArrE;
}
-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self httpRequest];
    
    [self setUpCollectionView];
    
    [self registerCollectionCell];
    
    
//    [self.collectionView headerBeginRefreshing];
//    [self.collectionView addHeaderWithTarget:self action:@selector(httpRequest)];
//    
}

- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 45 - 85);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.flowLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
}

#pragma mark -  注册cell
- (void)registerCollectionCell
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"hotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RecommandCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WritingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WritingCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GGRecomHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GGRecomHeaderView"];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section > 1) {
//        return 1;
//    }
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = @"hotCollectionViewCell";
    } else {
        cellID = @"RecommandCollectionViewCell";
    }

    
    GGBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.tempArrA.count > 0) {
            HotClassModal *hotModal = self.tempArrA[indexPath.row];
       
            [cell setCellModel:hotModal];
        }
    } else  {
        if (self.tempArrB.count > 0) {
            HotClassModal *recomModal = self.tempArrB[indexPath.row];
        
            [cell setCellModel:recomModal];
        }
        
    }

    
    return cell;
     
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 2) {
//        return CGSizeMake(ScreenWidth, ScreenWidth / 4);
//    } else if (indexPath.section == 3) {
//        return CGSizeMake(ScreenWidth, ScreenWidth / 4);
//    } else {
    //return CGSizeMake(ScreenWidth / 5 + 20, ScreenWidth / 4 + 10);
    return CGSizeMake((ScreenWidth-20)/2, (ScreenWidth-20)/2-10);
//    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GGRecomHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GGRecomHeaderView" forIndexPath:indexPath];
        [reusableView.goUp setTitle:@"更多" forState:UIControlStateNormal];
        if (indexPath.section == 0) {
            reusableView.goUp.tag = 100;
            [reusableView.goUp addTarget:self action:@selector(clickMoreClassBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            reusableView.goUp.tag = 101;
            [reusableView.goUp addTarget:self action:@selector(clickMoreClassBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        reusableView.name.text = self.tempArrE[indexPath.section];
        
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(ScreenWidth/5, 40);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HotClassModal *hot = self.tempArrA[indexPath.row];
        NSString *playerID = hot.openClassID;
        [self stringFromPlist:playerID andOther:@"OPEN"];
        LYPlayerViewController *player = [[LYPlayerViewController alloc]initWithVideoId:playerID andComeFromWhichVC:@"TWO"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
    } else {
        
        ReconmmandModal *recommand = self.tempArrB[indexPath.row];
        NSString *RePlayerID = recommand.openClassID;
        [self stringFromPlist:RePlayerID andOther:@"OPEN"];
        LYPlayerViewController *player = [[LYPlayerViewController alloc]initWithVideoId:RePlayerID andComeFromWhichVC:@"TWO"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
        
    }
}


//数据持久化到plist文件
- (NSString *)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    return fileName;
}

- (void)stringFromPlist:(NSString *)classid andOther:(NSString *)other
{
    NSString *pathStr = [self getDataFilePath];
    NSLog(@"%@",pathStr);
    if (!pathStr) {
        return;
    }
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    [data addObject:classid];
    [data addObject:other];
    
    [data writeToFile:pathStr atomically:YES];
    
}





#pragma mark - httpRequest
- (void)httpRequest
{
    
    if (self.dataDic) {
        [self.tempArrA removeAllObjects];
        [self.tempArrB removeAllObjects];
        [self.tempArrC removeAllObjects];
    }
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    //热门课程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kRMClassUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //NSLog(@"CLASS---->%@",responseObject);
        
        
        NSString *imageStr = responseObject[@"kc_imgurl"];
        [tools saveToPlistWithPlistName:@"HotClass.plist" andData:imageStr];
        
        
        self.tempArrA = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            HotClassModal *hot = [[HotClassModal alloc] init];
            hot.title = dic[@"KCMC"];
            hot.imgUrl = dic[@"KCTP"];
            hot.openClassID = dic[@"KCID"];
            hot.classesNum = [dic[@"kscount"] stringValue];
            hot.classesEnd = [dic[@"xxcount"] stringValue];
            [self.tempArrA addObject:hot];
        }
        
        [self.dataDic setValue:self.tempArrA forKey:@"A"];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView footerEndRefreshing];
        });
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"hot error---%@",error.userInfo);
       
    }];
        });
    
    //推荐课程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    AFHTTPRequestOperationManager *managerForTJ = [AFHTTPRequestOperationManager manager];
    [managerForTJ GET:kTJClassUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        
        NSString *imageStr = responseObject[@"kc_imgurl"];
        [tools saveToPlistWithPlistName:@"RecommendClass.plist" andData:imageStr];
        
        self.tempArrB = [NSMutableArray array];
        self.tempArrC = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            ReconmmandModal *reconmmand = [[ReconmmandModal alloc]init];
//            WritingModal *writing = [[WritingModal alloc] init];
            reconmmand.title = dic[@"KCMC"];
            reconmmand.imgUrl = dic[@"KCTP"];
            reconmmand.openClassID = dic[@"KCID"];
            reconmmand.number = dic[@"kscount"];
            reconmmand.people = dic[@"xxcount"];
            

            [self.tempArrB addObject:reconmmand];
        }
        [self.dataDic setValue:self.tempArrB forKey:@"B"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
//            [self.collectionView footerEndRefreshing];
        });
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"reconmmand error---%@",error.userInfo);
        
    }];
        });
    
}


- (void)clickMoreClassBtn:(UIButton *)sender
{
    NSLog(@"###########%ld",sender.tag);
    NSString *buttonTag = nil;
    if (sender.tag == 100) {
        buttonTag = kFirstSectionMoreBtnTag;
    } else {
        buttonTag = kSecondSectionMoreBtnTag;
    }
    
    MoreViewController *moreVC = [[MoreViewController alloc] initWithButtonTag:buttonTag];
    
    [self.navigationController pushViewController:moreVC animated:YES];
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
