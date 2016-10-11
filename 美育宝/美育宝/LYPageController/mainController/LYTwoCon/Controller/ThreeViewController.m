//
//  ThreeViewController.m
//  Page Demo
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ThreeViewController.h"
#import "LYPlayerViewController.h"
#import "DetailTextViewController.h"
#import "MYSearchViewController.h"
#import "MYCellModal.h"
#import "MYRecommandCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "FormValidator.h"

#import "RecommandCollectionViewCell.h"
#import "GGRecomHeaderView.h"
#import "GGBaseCell.h"
#import "Recommand.h"
#import "MYToolsModel.h"
#import "LrdSuperMenu.h"

//static NSString* oneStep = nil;
//static NSString* twoStep = nil;
//static NSString* threeStep = nil;

#define RecommendUrl @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzylist&jd=&nj=1&km=150101&jcdm=&dybh=&zbh=&lb=&orderBy=&pageindex=&pagesize=1000"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ThreeViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LrdSuperMenuDelegate, LrdSuperMenuDataSource>
{
    NSString* oneStep;
    NSString* twoStep;
    NSString* threeStep;
}

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)NSMutableArray *tempA;
@property (nonatomic, strong)NSMutableArray *tempB;

@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSMutableArray *choose;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classes;
@property (nonatomic, strong) NSMutableArray *stage;
@property (nonatomic, strong) NSMutableArray *grade;
@property (nonatomic, strong) NSMutableArray *subject;
@property (nonatomic, strong) NSMutableArray *edition;

@property (nonatomic, strong) NSArray *jiachang;
@property (nonatomic, strong) NSArray *difang;
@property (nonatomic, strong) NSArray *tese;
@property (nonatomic, strong) NSArray *rihan;
@property (nonatomic, strong) NSArray *xishi;
@property (nonatomic, strong) NSArray *shaokao;

@property(nonatomic , strong) NSMutableDictionary *dataDic;

@end

@implementation ThreeViewController

- (NSMutableArray *)classify
{
    if (!_classify) {
        _classify = [NSMutableArray arrayWithObject:@"学习阶段"];
        [_classify addObjectsFromArray:[self getEducationStage]];
    }
    return _classify;
}

- (NSMutableArray *)stage
{
    if (!_stage) {
        _stage = [[NSMutableArray alloc] init];
    }
    return _grade;
}

- (NSArray *)sort
{
    if (!_sort) {
        _sort = [NSMutableArray arrayWithObject:@"年级"];
        [_sort addObjectsFromArray:[self getSmallStageWithIndex:nil andIndex:0]];
    }
    return _sort;
}

- (NSMutableArray *)grade
{
    if (!_grade) {
        _grade = [[NSMutableArray alloc] init];
    }
    return _grade;
}

- (NSMutableArray *)choose
{
    if (!_choose) {
        _choose = [NSMutableArray arrayWithObject:@"科目"];
        [_choose addObjectsFromArray:[self getAllSubject]];
    }
    return _choose;
}

- (NSMutableArray *)subjectCode
{
    if (!_subject) {
        _subject = [NSMutableArray array];
    }
    return _subject;
}

- (NSMutableArray *)classes
{
    if (!_classes) {
        
        _classes = [NSMutableArray array];
        [_classes removeAllObjects];
        [_classes addObjectsFromArray:[self getSubjectCodeWithGrade:nil andSubjectID:nil toIndex:0]];
    }
    return _classes;
}

- (NSMutableArray *)edition
{
    if (!_edition) {
        _edition = [NSMutableArray array];
    }
    return _edition;
}


- (NSMutableArray *)tempA
{
    if (!_tempA) {
        _tempA = [[NSMutableArray alloc] init];
    }
    return _tempA;
}
- (NSMutableArray *)tempB
{
    if (!_tempB) {
        _tempB = [[NSMutableArray alloc] init];
    }
    return _tempB;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"教学资源检索";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    //网络请求
    [self httpRequestWithStage:nil andGrade:nil andSubject:nil andEdition:nil toIndex:0];
    //设置collectionview
    [self setUpCollectionView];
    
    //顶部搜索
    [self setupItems];
    //筛选栏
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
    
   
    
    //注册collectioncell
    [self registerCollectionCell];
    
    [self.collectionView headerBeginRefreshing];
//    [self.collectionView addHeaderWithTarget:self action:@selector(httpRequestWithStage:andGrade:andSubject:andEdition:toIndex:)];
    
    
    
}

//导航栏
- (void)setupItems{
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    
    self.navigationItem.rightBarButtonItem = barItem;
    
}

-(void)clickLeftButton {
    MYSearchViewController *search = [[MYSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    
}

- (void)setUpCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGRect rect = CGRectMake(0,0, ScreenWidth, ScreenHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.flowLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    //self.view.backgroundColor = [UIColor whiteColor];
   // NSLog(@"%@",[NSValue valueWithCGRect:self.view.frame]);
}

#pragma mark -  注册cell
- (void)registerCollectionCell
{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYRecommandCell" bundle:nil] forCellWithReuseIdentifier:@"MYRecommandCell"];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.tempB.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"MYRecommandCell";
    
    MYRecommandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
        if (self.tempB.count > 0) {
            Recommand *myModal = self.tempB[indexPath.row];
            [cell setCollectionViewCellModel:myModal];
         
        }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 5) {
//        return CGSizeMake(ScreenWidth / 6 + 15, ScreenWidth / 4 + 10);
   // } else
//    if (indexPath.section > 5){
//        return CGSizeMake(ScreenWidth, ScreenWidth / 4);
//    } else{
        //return CGSizeMake(ScreenWidth / 5 + 20, ScreenWidth / 4 + 10);
        return CGSizeMake((ScreenWidth-20)/2, (ScreenWidth-20)/2-10);
   // }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(5, 5, 5, 5);
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.section < 6) {
    UICollectionReusableView *collection = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GGRecomHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GGRecomHeaderView" forIndexPath:indexPath];
        [reusableView.goUp setTitle:@"更多" forState:UIControlStateNormal];
        reusableView.name.text = self.tempE[indexPath.section];
        collection = reusableView;
        return collection;
    }
    
    return  nil;
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section > 5) {
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(ScreenWidth/5, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Recommand *recommand = self.tempB[indexPath.row];
    NSString *playerID   = recommand.playerID;
    
    if ([recommand.sourseType isEqualToString:@".png"] || [recommand.sourseType isEqualToString:@".jpg"]) {
        DetailTextViewController *detailVC = [[DetailTextViewController alloc]initWithImageString:recommand.imgUrl commemtID:recommand.sourseID from:@"THREE" title:recommand.className];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        
        LYPlayerViewController *player = [[LYPlayerViewController alloc] initWithVideoId:playerID andComeFromWhichVC:@"THREE"];
        player = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateViewControllerWithIdentifier:@"LYPlayerViewController"];
        [self presentViewController:player animated:YES completion:nil];
    }
    
    
}



#pragma mark - httpRequest
- (void)httpRequestWithStage:(NSString *)stage andGrade:(NSString *)grade andSubject:(NSString *)subject andEdition:(NSString *)edition toIndex:(NSInteger)index
{
    NSString *urlString = nil;
    if (index == 0) {
        urlString = RecommendUrl;
    } else {
        urlString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzylist&jd=%@&nj=%@&km=%@&jcdm=%@&dybh=&zbh=&lb=&orderBy=&pageindex=&pagesize=",stage, grade, subject, edition];
    }
//    NSLog(@"%@",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
            [FormValidator showAlertWithStr:@"暂无数据，先看看其他课程吧！"];
            return;
        }
        
        if (self.dataDic) {
            [self.tempB removeAllObjects];
        }
        MYToolsModel *tools = [MYToolsModel new];
        NSString *imageStr = responseObject[@"imgurl"];
        [tools saveToPlistWithPlistName:@"Three.plist" andData:imageStr];
        
        
        self.tempB = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
           Recommand *myModal = [[Recommand alloc]init];
            myModal.className = dic[@"ZYMC"];
            myModal.imgUrl = dic[@"IMGPATH"];
            myModal.playerID = dic[@"SWF"];
            myModal.sourseType = dic[@"ZYLX"];
            myModal.sourseID   = dic[@"MXDM"];
            [self.tempB addObject:myModal];
        }
        
        [self.dataDic setValue:self.tempB forKey:@"tempB"];
        [self.collectionView reloadData];
        [self.collectionView headerBeginRefreshing];
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"Three error--%@",error.userInfo);
    }];
}


//获取教育阶段
- (NSArray *)getEducationStage
{
    NSMutableArray *sort = [NSMutableArray array];
    
    NSString *str = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatajd";
    NSString *urlstr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlstr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    for (NSDictionary *params in dic[@"data"]) {
        
        [sort addObject:params[@"ZDMC"]];
    }
    
    return sort;
}

//获取年级 一年级，二年级，三年级。。。。
- (NSArray *)getSmallStageWithIndex:(NSString *)code andIndex:(NSInteger)index
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *httpString = nil;
    if (index == 0) {
        httpString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=004001";
    } else {
        httpString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=%@",code];
    }
    //NSLog(@"%@",httpString);
    NSString *codeUrl = [httpString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *httpUrl = [NSURL URLWithString:codeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if ([dict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    [self.grade removeAllObjects];
    for (NSDictionary *diction in dict[@"data"]) {
        [self.grade addObject:diction[@"BH"]];
        [array addObject:diction[@"NJBM"]];
        
    }
    
    
    
    return array;
}

//获取所有科目
- (NSArray *)getAllSubject
{
    NSMutableArray *subjectArr = [NSMutableArray array];
    
    NSString *urlString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatakm";
    NSString *codeStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:codeStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    [self.subject removeAllObjects];
    for (NSDictionary *grade in params[@"data"]) {
        
        [subjectArr addObject:grade[@"KCMC"]];
        [self.subject addObject:grade[@"KCH"]];
//        NSLog(@"---%@",grade[@"KCH"]);
    }
    
    
    return subjectArr;
}

//获取教材代码
- (NSArray *)getSubjectCodeWithGrade:(NSString *)grade andSubjectID:(NSString *)subjectID toIndex:(NSInteger)index
{
    NSMutableArray *subjectCode = [NSMutableArray array];
    
    NSString *urlString = nil;
    if (index == 0) {
        urlString = @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getjclist&nj=1&km=150101";
    } else {
        urlString = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getjclist&nj=%@&km=%@",grade, subjectID];
       // NSLog(@"%@",urlString);
    }
    
    
    NSString *codeString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *codeUrl = [NSURL URLWithString:codeString];
    NSURLRequest *request = [NSURLRequest requestWithURL:codeUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data) {
        return nil;
    }
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //NSLog(@"%@",dataDict);
    if ([dataDict[@"data"] isKindOfClass:[NSString class]]) {
        [FormValidator showAlertWithStr:@"暂无数据"];
        return nil;
    }
    [self.edition removeAllObjects];
    for (NSDictionary *params in dataDict[@"data"]) {
        [subjectCode addObject:params[@"JCMC"]];
        [self.edition addObject:params[@"JCDM"]];
//        NSLog(@"%@",params[@"JCMC"]);
    }
    
//    [_menu reloadData];
    return subjectCode;
}

- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        NSLog(@"1111");
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        NSLog(@"2222");
        if (indexPath.column == 0 && indexPath.row > 0) {
            
            
            NSArray *stageArr = [tools getDataArrayFromPlist:@"Stage.plist"];
            
            oneStep = stageArr[indexPath.row - 1];
            //NSLog(@"%@",oneStep);
            [self.sort removeAllObjects];
            [self.sort addObject:@"年级"];
            [self.sort addObjectsFromArray:[self getSmallStageWithIndex:oneStep andIndex:1]];
            
            
            
            [self httpRequestWithStage:self.stage[indexPath.row - 1] andGrade:@"" andSubject:@"" andEdition:@"" toIndex:1];
            
        } else if (indexPath.column == 1 && indexPath.row >0) {
            
            if (!oneStep) {
                oneStep = @"";
            }
            twoStep = self.grade[indexPath.row - 1];
            [self httpRequestWithStage:oneStep andGrade:twoStep andSubject:@"" andEdition:@"" toIndex:1];
            
            
            
            
        } else if (indexPath.column == 2 && indexPath.row > 0) {
            
            if (!oneStep) {
                oneStep = @"";
            }
            if (!twoStep) {
                twoStep = @"";
            }
            
            NSArray *subjectArr = [tools getDataArrayFromPlist:@"Subject.plist"];
            threeStep = subjectArr[indexPath.row - 1];
            [self httpRequestWithStage:oneStep andGrade:twoStep andSubject:threeStep andEdition:@"" toIndex:1];
            
            [self.classes removeAllObjects];
            [self.classes addObject:@"版本"];
            [self.classes addObjectsFromArray:[self getSubjectCodeWithGrade:twoStep andSubjectID:threeStep toIndex:1]];
            
        } else if (indexPath.column == 3 && indexPath.row > 0) {
            
            if (!oneStep) {
                oneStep = @"";
            }
            if (!twoStep) {
                twoStep = @"";
            }
            if (!threeStep) {
                threeStep = @"";
            }
            
            [self httpRequestWithStage:oneStep andGrade:twoStep andSubject:threeStep andEdition:self.edition[indexPath.row - 1] toIndex:1];
        }
    }
}



#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 4;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.classify.count;
    }else if(column == 1) {
        return self.sort.count;
    } else if (column == 2){
        return self.choose.count;
    } else {
        return self.classes.count;
    }
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.classify[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.sort[indexPath.row];
    } else if (indexPath.column == 2) {
        return self.choose[indexPath.row];
    }else {
        return self.classes[indexPath.row];
    }
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    //if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    //}
    //return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column < 2) {
        return [@(arc4random()%1000) stringValue];
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    return [@(arc4random()%1000) stringValue];
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        if (row == 3) {
            return self.jiachang.count;
        }else if (row == 4) {
            return self.difang.count;
        }else if (row == 5) {
            return self.tese.count;
        }else if (row == 6) {
            return self.rihan.count;
        }else if (row == 7) {
            return self.xishi.count;
        }else if (row == 8) {
            return self.shaokao.count;
        }
    }
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        if (row == 3) {
            return self.jiachang[indexPath.item];
        }else if (row == 4) {
            return self.tese[indexPath.item];
        }else if (row == 5) {
            return self.rihan[indexPath.item];
        }else if (row == 6) {
            return self.xishi[indexPath.item];
        }else if (row == 7) {
            return self.shaokao[indexPath.item];
        }
    }
    return nil;
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
