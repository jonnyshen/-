//
//  LYOneViewController.m
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYOneViewController.h"
#import "KJCustomButton.h"
#import "MJRefresh.h"
#import "FirstHeaderViewCell.h"

#import "GGRecomScrollCell.h"
//#import "GGListClassCell.h"
#import "MoreDetailController.h"
#import "MorePlayerSourceController.h"
#import "GGListClassModel.h"
//#import "SDCycleScrollView.h"
#import "GGMovieModel.h"
#import "MYOutSide.h"
#import "GGBaseCell.h"
#import "MYOutSideClassCell.h"
#import "GGRecomHeaderView.h"
#import "AFNetworking.h"

#import "LYPlayerViewController.h"
#import "DetailTextViewController.h"
#import "LoginViewController.h"
#import "LoginState.h"
#import "MYToolsModel.h"
#import "MYExerciseDetailController.h"
#import "MessageDetailController.h"
#import "CycleScrollView.h"

//首页接口
#define RecommendUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getindexinfo"
#define kTEXTURL @""


#define kView_W self.view.frame.size.width
#define kView_H self.view.frame.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LYOneViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,CycleScrollViewDelegate,GGRecomScrollCellDelegate>
{
    NSString *_playerId;
    NSString *_title;
    NSString *_imageUrl;
    NSString *_schoolOROpen;

}
@property (nonatomic, strong) GGRecomScrollCell *scrollCell;


/**
 *  轮播图数据
 */
@property (nonatomic,strong)NSMutableArray *scrollDatas;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewLayout *flowLayout;

@property(nonatomic , strong) NSMutableArray  *tempArrA;
@property(nonatomic , strong) NSMutableArray  *tempArrB;
@property(nonatomic , strong) NSMutableArray  *tempArrC;
@property(nonatomic , strong) NSMutableArray  *tempArrD;
@property(nonatomic , strong) NSArray  *tempArrE;
@property(nonatomic , strong) NSMutableArray  *tempArrF;

@property(nonatomic , strong) NSMutableDictionary *dataDic;

@end

@implementation LYOneViewController

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
-(NSMutableArray *)tempArrD{
    if (_tempArrD == nil) {
        _tempArrD = [[NSMutableArray alloc]init];
    }
    return _tempArrD;
}
-(NSArray *)tempArrE{
    if (_tempArrE == nil) {
        _tempArrE = @[@"推荐资源", @"校本课程", @"公开课", @"学生作品", @"课外活动", @""];
    }
    return _tempArrE;
}
-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (GGRecomScrollCell *)scrollCell
{
    if (!_scrollCell) {
        _scrollCell = [[GGRecomScrollCell alloc] init];
        _scrollCell.mainScorllView.delegate = self;
    }
    return _scrollCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadCollectionView];
    [self registerCell];
    [self httpRequest];
    
    [self.collectionView addHeaderWithTarget:self action:@selector(httpRequest)];
    [self.collectionView headerBeginRefreshing];
    

//    self.scrollCell.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerViewClick:) name:@"FIRSTVC_HEADERVIEW_CLICK" object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FIRSTVC_HEADERVIEW_CLICK" object:nil];
}

- (void)headerViewClick:(NSNotification *)notification
{
//    NSLog(@"%@--%@",notification.userInfo[@"newsID"],notification.userInfo[@"newsTitle"]);
    MessageDetailController *messagevc = [[MessageDetailController alloc] initWithNewsID:notification.userInfo[@"newsID"]];
    messagevc.title = notification.userInfo[@"newsTitle"];
    [self.navigationController pushViewController:messagevc animated:YES];
    

}

#pragma mark -添加collectionView
-(void)reloadCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 -40);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.flowLayout = flowLayout;
    self.collectionView = collectionView;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    

    
}
#pragma mark -注册cell
- (void)registerCell{
    [self.collectionView registerClass:[MYOutSideClassCell class] forCellWithReuseIdentifier:@"MYOutSideClassCell"];
    [self.collectionView registerClass:[GGRecomScrollCell class] forCellWithReuseIdentifier:@"GGRecomScrollCell"];
//    [self.collectionView registerClass:[FirstHeaderViewCell class] forCellWithReuseIdentifier:@"FirstHeaderViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GGMovieCell" bundle:nil] forCellWithReuseIdentifier:@"GGMovieCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GGRecomHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GGRecomHeaderView"];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else if (section == 4) {
        return self.tempArrD.count;
    } else if (section == 1) {
        return self.tempArrA.count;
    } else if (section == 2) {

        
            return self.tempArrB.count;

    } else if (section == 3) {
        return self.tempArrC.count;
    } else if (section == 5) {

            return self.tempArrF.count;

    }
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenWidth, ScreenWidth/7*3);
    }//else if(indexPath.section == 1){
        //return CGSizeMake(ScreenWidth, ScreenWidth/5+20);
    //}
    return CGSizeMake((ScreenWidth-20)/2, (ScreenWidth-20)/2-10);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = nil;
    
    if (indexPath.section == 0) {
        cellID = @"GGRecomScrollCell";
    } else {
        cellID = @"GGMovieCell";
    }
    
    
    GGBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        
        
        [cell setCellModel:@"A"];
        return cell;
    }
    else{
//        static NSString *cellID = nil;
        
        
        if (indexPath.section ==1 ) {
            if (self.tempArrA.count>0) {
                GGMovieModel *model = self.tempArrA[indexPath.row];
                [cell setCellModel:model];
            }
            
        }else if (indexPath.section == 2) {
            
            if (self.tempArrB.count>0) {
                GGMovieModel *model = self.tempArrB[indexPath.row];
                [cell setCellModel:model];
            }
            
        }else if (indexPath.section == 3) {
            if (self.tempArrC.count>0) {
                GGMovieModel *model = self.tempArrC[indexPath.row];
                [cell setCellModel:model];
            }
            
        }else if (indexPath.section == 4){
            if (self.tempArrD.count>0) {
                GGMovieModel *model = self.tempArrD[indexPath.row];
                [cell setCellModel:model];
            }
        } else if (indexPath.section == 5) {
            if (self.tempArrF.count > 0) {
                GGMovieModel *outSide = self.tempArrF[indexPath.row];
                [cell setCellModel:outSide];
            }
        }
        
        return cell;
    }
    
}
//屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0||section == 1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            GGRecomHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GGRecomHeaderView" forIndexPath:indexPath];
            
            [reusableView.goUp addTarget:self action:@selector(clickMoreDetail) forControlEvents:UIControlEventTouchUpInside];
            
            if (indexPath.section == 1 && self.tempArrA.count > 0) {
                reusableView.name.text = self.tempArrE[indexPath.section - 1];
//                return reusableView;
            } else if (indexPath.section == 2 && self.tempArrB.count > 0) {
                reusableView.name.text = self.tempArrE[indexPath.section - 1];
                
//                return reusableView;
            } else if (indexPath.section == 3 && self.tempArrC.count > 0) {
                reusableView.name.text = self.tempArrE[indexPath.section - 1];
                
//                return reusableView;
            } else if (indexPath.section == 4 && self.tempArrD.count > 0) {
                reusableView.name.text = self.tempArrE[indexPath.section - 1];
                
//                return reusableView;
            } else if (indexPath.section == 5 && self.tempArrF.count > 0) {
                reusableView.name.text = self.tempArrE[indexPath.section - 1];
                
            }
            
            return reusableView;
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section >0) {
        return CGSizeMake(ScreenWidth, 40);
    }
    return CGSizeMake(0, 0);
}

- (void)clickMoreDetail
{
    MoreDetailController *moreDetailVC = [[MoreDetailController alloc] init];
    [self.navigationController pushViewController:moreDetailVC animated:YES];
}
- (void)clickMorePlayerSource
{
    MorePlayerSourceController *morePlayerSource = [[MorePlayerSourceController alloc] init];
    
    [self.navigationController pushViewController:morePlayerSource animated:YES];
}

#pragma mark -解析网络数据
- (void)httpRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:RecommendUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
       // NSLog(@"－－－－－%@",responseObject);
        
        if (self.dataDic) {
            [self.dataDic removeAllObjects];
            [self.tempArrA removeAllObjects];
            [self.tempArrB removeAllObjects];
            [self.tempArrC removeAllObjects];
            [self.tempArrD removeAllObjects];
            
        }
        
        self.tempArrA = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"tjzy_data"]) {
            GGMovieModel *scrM = [[GGMovieModel alloc]init];
            scrM.title = dic[@"UserName"];
            scrM.imgUrl = dic[@"imgUrl"];
            scrM.nickName = dic[@"TJJB"];
            scrM.classID = dic[@"MXDM"];
            [self.tempArrA addObject:scrM];
        }
        
        self.tempArrB = [NSMutableArray array];
//        if ([responseObject[@"xbkc_data"] isEqualToString:@"暂无数据"]) {
//            
//        } else {
            for (NSDictionary *dic in responseObject[@"xbkc_data"]) {
                GGMovieModel *classM = [[GGMovieModel alloc]init];
                classM.title = dic[@"KCH"];
                classM.imgUrl = dic[@"imgUrl"];
                classM.nickName = dic[@"KCMC"];
                classM.classID = dic[@"BKID"];
                [self.tempArrB addObject:classM];
            }
//        }
        
        
        
        
        self.tempArrC = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"gkkcy_data"]) {
            GGMovieModel *headerModel = [[GGMovieModel alloc]init];
            headerModel.title = dic[@"KCMC"];
            headerModel.imgUrl = dic[@"imgUrl"];
            headerModel.nickName = dic[@"KCMC"];
            headerModel.classID = [NSString stringWithFormat:@"%@",dic[@"KCID"]];
            [self.tempArrC addObject:headerModel];
            
        }
        
        self.tempArrD = [NSMutableArray array];
        if ([responseObject[@"xszp_data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *dic in responseObject[@"xszp_data"]) {
                GGMovieModel *headerModal = [[GGMovieModel alloc]init];
                headerModal.title = dic[@"ZYMC"];
                headerModal.imgUrl = dic[@"imgUrl"];
                headerModal.nickName = dic[@"SCSJ"];
                headerModal.classID = dic[@"MXDM"];
                [self.tempArrD addObject:headerModal];
                
            }
        }
        
//        if ([responseObject[@"kwhd_data"] isEqualToString:@"暂无数据"]) {
//            
//        } else {
            self.tempArrF = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"kwhd_data"]) {
                GGMovieModel *headerModal = [[GGMovieModel alloc]init];
                headerModal.title = dic[@"HDMC"];
                headerModal.imgUrl = dic[@"imgUrl"];
                //            headerModal.nickName = @"";
                headerModal.classID = dic[@"infourl"];
                [self.tempArrF addObject:headerModal];
            }
//        }
        
        
       
//        NSLog(@"a:%@,b:%@,c:%@,d:%@",self.tempArrA,self.tempArrB,self.tempArrC,self.tempArrD);
        
        [self.dataDic setObject:self.tempArrA forKey:@"A"];
        [self.dataDic setObject:self.tempArrB forKey:@"B"];
        [self.dataDic setObject:self.tempArrC forKey:@"C"];
        [self.dataDic setObject:self.tempArrD forKey:@"D"];
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//首页cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.tempArrA.count == 0) {
            return;
        }
        GGMovieModel *model = self.tempArrA[indexPath.row];
        _playerId = model.classID;
        _title = model.title;
        _imageUrl = model.imgUrl;
        [self stringFromPlist:_playerId andOther:@""];
        [self saveDataToPlist];
        DetailTextViewController *detail = [[DetailTextViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
        
    } else if (indexPath.section == 2) {
        
        if (self.tempArrB.count == 0) {
            return;
        }
        
        if ([LoginState isLogin]) {
            GGMovieModel *model = self.tempArrB[indexPath.row];
            _playerId = model.classID;
            [self stringFromPlist:_playerId andOther:@""];
            LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:model.classID andComeFromWhichVC:@"ONE"];
            player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
            [self presentViewController:player animated:YES completion:nil];
        } else {
            [LoginViewController login:self loginType:LoginType_Normal];
        }
        
        /*
        if (self.tempArrC.count == 0) {
            return;
        }
        if ([LoginState isLogin]) {
            GGMovieModel *model = self.tempArrC[indexPath.row];
            _playerId           = model.classID;
            _schoolOROpen       = @"OPEN";
            [self stringFromPlist:_playerId andOther:_schoolOROpen];
            LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:model.classID andComeFromWhichVC:@"TWO"];
            player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
            [self presentViewController:player animated:YES completion:nil];
        } else {
            [LoginViewController login:self loginType:LoginType_Normal];
        }
        */
        
    } else if (indexPath.section == 3) {
        if (self.tempArrC.count == 0) {
            return;
        }
        if ([LoginState isLogin]) {
            GGMovieModel *model = self.tempArrC[indexPath.row];
            _playerId           = model.classID;
            _schoolOROpen       = @"OPEN";
            [self stringFromPlist:_playerId andOther:_schoolOROpen];
            LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:model.classID andComeFromWhichVC:@"TWO"];
            player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
            [self presentViewController:player animated:YES completion:nil];
        } else {
            [LoginViewController login:self loginType:LoginType_Normal];
        }
        
      } else if (indexPath.section == 4) {
        if (self.tempArrD.count == 0) {
            return;
        }
        GGMovieModel *model = self.tempArrD[indexPath.row];
        _playerId = model.classID;
        _title = model.title;
        _imageUrl = model.imgUrl;
        [self stringFromPlist:_playerId andOther:@""];
        [self saveDataToPlist];
        DetailTextViewController *detail = [[DetailTextViewController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    } else if (indexPath.section == 5) {
        
        GGMovieModel *modelFive = self.tempArrF[indexPath.row];
        
        MYExerciseDetailController *detail = [[MYExerciseDetailController alloc]initWithExerciseID:modelFive.classID andhtmlLink:@""];

        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma mark - LYOneViewControllerDelegate

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

- (void)saveDataToPlist
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"TitltAndImage.plist"];
    
    NSLog(@"%@",fileName);
    if (!fileName) {
        return;
    }
    NSMutableArray *data = [[NSMutableArray alloc] init];
   
    [data addObject:_title];
    
    [data addObject:_imageUrl];
    
    [data writeToFile:fileName atomically:YES];
    
}


-(NSMutableArray *)scrollDatas
{
    if (_scrollDatas==nil)
    {
        _scrollDatas=[NSMutableArray array];
    }
    return _scrollDatas;
}


- (void)didSelectImageAtIndex:(NSInteger)index
{
    NSLog(@"index=%ld",index);
}

- (void)didSelectScrollAtIndex:(NSString *)index
{
    
}

@end
