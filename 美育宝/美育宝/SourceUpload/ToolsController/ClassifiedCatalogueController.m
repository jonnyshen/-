//
//  ClassifiedCatalogueController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "ClassifiedCatalogueController.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"
#import "EducationStage.h"
#import "FirstInDefault.h"
#import "GradeEducation.h"
#import "SubjectModel.h"
#import "TeachingMaterial.h"
#import "UnitsModel.h"
#import "PeriodClass.h"
#import "ArrowAngleView.h"
#import "UILabel+AttributedString.h"

@interface ClassifiedCatalogueController ()<ArrowAngleViewDelegate,UIGestureRecognizerDelegate>
{
    ArrowAngleView *arrowView;
   ArrowAngleView *arrowViewTwo;
    ArrowAngleView *arrowViewThree;
    ArrowAngleView *arrowViewFour;
    ArrowAngleView *arrowViewFive;
    ArrowAngleView *arrowViewSix;
    UILabel *titleLabel;
}
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreCatalogueBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (nonatomic, strong) NSMutableArray *defaultArray;
@property (nonatomic, strong) NSMutableArray *stageArr;

@property (nonatomic, strong) NSMutableArray *gradeArr;

@property (nonatomic, strong) NSMutableArray *subjectArr;
@property (nonatomic, strong) NSMutableArray *nianjiID;
@property (nonatomic, strong) NSMutableArray *kemuID;
@property (nonatomic, strong) NSMutableArray *danyuanID;
@property (nonatomic, strong) NSMutableArray *keshiID;

@property (nonatomic, strong) NSMutableArray *teachMaterialArr;
@property (nonatomic, strong) NSMutableArray *unitsArr;
@property (nonatomic, strong) NSMutableArray *periodArr;


@property (nonatomic, strong) NSMutableArray *oneDataArr;
@property (nonatomic, strong) NSMutableArray *twoDataArr;
@property (nonatomic, strong) NSMutableArray *threeDataArr;
@property (nonatomic, strong) NSMutableArray *fourDataArr;
@property (nonatomic, strong) NSMutableArray *fiveDataArr;
@property (nonatomic, strong) NSMutableArray *sixDataArr;

@end

@implementation ClassifiedCatalogueController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getFirstSightMessage];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissArrowView)];
    tap.delegate = self;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    [self.oneBtn addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn addTarget:self action:@selector(twoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn addTarget:self action:@selector(threeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourBtn addTarget:self action:@selector(fourBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveBtn addTarget:self action:@selector(fiveBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sixBtn addTarget:self action:@selector(sixBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
}



- (void)dismissArrowView{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
}

- (void)oneBtnClick:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    //    NSLog(@"%f",button.frame.origin.x);
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowView = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 100))];
    arrowView.delegate = self;
    arrowView.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (EducationStage *data in self.stageArr) {
        [dataArr addObject:data.stageName];
    }
    self.oneDataArr = dataArr;
    arrowView.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowView];
    
    
}

- (void)twoBtnAction:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    //    NSLog(@"%f",button.frame.origin.x);
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowViewTwo = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 300))];
    arrowViewTwo.delegate = self;
    arrowViewTwo.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (GradeEducation *data in self.gradeArr) {
        [dataArr addObject:data.njbm];
    }
    self.twoDataArr = dataArr;
    arrowViewTwo.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowViewTwo];
    
    
}

- (void)threeBtnClickAction:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowViewThree = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 300))];
    arrowViewThree.delegate = self;
    arrowViewThree.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (SubjectModel *data in self.subjectArr) {
        [dataArr addObject:data.kcmc];
    }
    self.threeDataArr = dataArr;
    arrowViewThree.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowViewThree];
    
   
}

- (void)fourBtnClickAction:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowViewFour = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 300))];
    arrowViewFour.delegate = self;
    arrowViewFour.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (TeachingMaterial *data in self.teachMaterialArr) {
        [dataArr addObject:data.jcmc];
    }
    self.fourDataArr = dataArr;
    arrowViewFour.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowViewFour];
    
    
}

- (void)fiveBtnClickAction:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowViewFive = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 300))];
    arrowViewFive.delegate = self;
    arrowViewFive.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (UnitsModel *data in self.unitsArr) {
        [dataArr addObject:data.bt];
    }
    self.fiveDataArr = dataArr;
    arrowViewFive.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowViewFive];
    
   
}

- (void)sixBtnClickAction:(UIButton *)button
{
    [arrowView removeFromSuperview];
    [arrowViewTwo removeFromSuperview];
    [arrowViewThree removeFromSuperview];
    [arrowViewFour removeFromSuperview];
    [arrowViewFive removeFromSuperview];
    [arrowViewSix removeFromSuperview];
    
    CGFloat x = button.frame.origin.x>375.0/2?130:CGRectGetMinX(button.frame);
    arrowViewSix = [[ArrowAngleView alloc] initWithFrame:(CGRectMake(x, CGRectGetMaxY(button.frame), 200, 250))];
    arrowViewSix.delegate = self;
    arrowViewSix.targetRect = button.frame;
    NSMutableArray *dataArr = [NSMutableArray array];
    for (PeriodClass *data in self.periodArr) {
        [dataArr addObject:data.bt];
    }
    self.sixDataArr = dataArr;
    arrowViewSix.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self.view addSubview:arrowViewSix];
    
   
}

- (void)getFirstSightMessage
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    NSString *firstUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getuseractionrecord&ucode=%@",userCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:firstUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        for (NSDictionary *first in responseObject[@"data"]) {
            FirstInDefault *defaultIN = [FirstInDefault dataWithDict:first];
            [self.defaultArray addObject:defaultIN];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    //获取教育阶段
    NSString *educationStageUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatajd&teachercode=%@",relationCode];
    
    [manager GET:educationStageUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *education in responseObject[@"data"]) {
                [self.oneDataArr addObject:education[@"ZDMC"]];
                EducationStage *stage = [EducationStage dataWithDict:education];
                [self.stageArr addObject:stage];
            }
            [self.oneBtn setTitle:self.oneDataArr.firstObject forState:UIControlStateNormal];
        }
     
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    //获取年级
    
    NSString *grade_Url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=004002&teachercode=%@",relationCode];
    
    [manager GET:grade_Url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.nianjiID addObject:grade[@"NJJD"]];
                [self.twoDataArr addObject:grade[@"NJBM"]];
                GradeEducation *stage = [GradeEducation dataWithDict:grade];
                [self.gradeArr addObject:stage];
            }
            
            [self.twoBtn setTitle:self.twoDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    //获取科目
    
    
    [manager GET:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatakm&teachercode=&nj=" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.kemuID addObject:grade[@"KCH"]];
                [self.threeDataArr addObject:grade[@"KCMC"]];
                SubjectModel *stage = [SubjectModel dataWithDict:grade];
                [self.subjectArr addObject:stage];
            }
            
            [self teachingMaterial];
            [self.threeBtn setTitle:self.threeDataArr.firstObject forState:UIControlStateNormal];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    

}

- (void)teachingMaterial
{
    //获取教材上下册
    NSString *teaching_Material_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getjclist&nj=1&km=150101"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:teaching_Material_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.danyuanID addObject:grade[@"JCDM"]];
                [self.fourDataArr addObject:grade[@"JCMC"]];
                TeachingMaterial *stage = [TeachingMaterial dataWithDict:grade];
                [self.teachMaterialArr addObject:stage];
            }
            
            //            获取到教材代码再执行获取单元目录
            [self getUnits];
            
            [self.fourBtn setTitle:self.fourDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取单元目录
- (void)getUnits
{
    NSString *units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=%@",self.danyuanID.firstObject];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.keshiID addObject:grade[@"ZBH"]];
                [self.fiveDataArr addObject:grade[@"BT"]];
                UnitsModel *stage = [UnitsModel dataWithDict:grade];
                [self.unitsArr addObject:stage];
            }
            
            //获取到zbh后再执行获取课时
            [self periodClass];
            
            [self.fiveBtn setTitle:self.fiveDataArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//
- (void)periodClass
{
    NSString *period_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",self.keshiID.firstObject];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:period_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.sixDataArr addObject:grade[@"BT"]];
                PeriodClass *stage = [PeriodClass dataWithDict:grade];
                [self.periodArr addObject:stage];
            }
            [self.sixBtn setTitle:self.sixDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}



- (void)didSelectedWithIndexPath:(NSInteger)indexpath{
    
    NSLog(@"=====%ld",indexpath);
}

//解决触摸事件和点击cell的事件冲突的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
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

- (NSMutableArray *)stageArr
{
    if (!_stageArr) {
        _stageArr = [[NSMutableArray alloc] init];
    }
    return _stageArr;
}

- (NSMutableArray *)subjectArr
{
    if (!_subjectArr) {
        _subjectArr = [[NSMutableArray alloc] init];
        
    }
    return _subjectArr;
}
- (NSMutableArray *)gradeArr
{
    if (!_gradeArr) {
        _gradeArr = [[NSMutableArray alloc] init];
    }
    return _gradeArr;
}
- (NSMutableArray *)nianjiID
{
    if (!_nianjiID) {
        _nianjiID = [[NSMutableArray alloc] init];
    }
    return _nianjiID;
}
- (NSMutableArray *)kemuID
{
    if (!_kemuID) {
        _kemuID = [[NSMutableArray alloc] init];
    }
    return _kemuID;
}
- (NSMutableArray *)teachMaterialArr
{
    if (!_teachMaterialArr) {
        _teachMaterialArr = [[NSMutableArray alloc] init];
    }
    return _teachMaterialArr;
}
- (NSMutableArray *)unitsArr
{
    if (!_unitsArr) {
        _unitsArr = [[NSMutableArray alloc] init];
    }
    return _unitsArr;
}
- (NSMutableArray *)periodArr
{
    if (!_periodArr) {
        _periodArr = [[NSMutableArray alloc] init];
    }
    return _periodArr;
}
- (NSMutableArray *)danyuanID
{
    if (!_danyuanID) {
        _danyuanID = [[NSMutableArray alloc] init];
    }
    return _danyuanID;
}
-(NSMutableArray *)keshiID
{
    if (!_keshiID) {
        _keshiID = [[NSMutableArray alloc] init];
    }
    return _keshiID;
}
- (NSMutableArray *)defaultArray
{
    if (!_defaultArray) {
        _defaultArray = [[NSMutableArray alloc] init];
    }
    return _defaultArray;
}
- (NSMutableArray *)oneDataArr
{
    if (!_oneDataArr) {
        _oneDataArr = [[NSMutableArray alloc] init];
    }
    return _oneDataArr;
}
- (NSMutableArray *)threeDataArr
{
    if (!_threeDataArr) {
        _threeDataArr = [[NSMutableArray alloc] init];
    }
    return _threeDataArr;
}
- (NSMutableArray *)twoDataArr
{
    if (!_twoDataArr) {
        _twoDataArr = [[NSMutableArray alloc] init];
    }
    return _twoDataArr;
}
- (NSMutableArray *)fourDataArr
{
    if (!_fourDataArr) {
        _fourDataArr = [[NSMutableArray alloc] init];
    }
    return _fourDataArr;
}
- (NSMutableArray *)fiveDataArr
{
    if (!_fiveDataArr) {
        _fiveDataArr = [[NSMutableArray alloc] init];
    }
    return _fiveDataArr;
}
- (NSMutableArray *)sixDataArr
{
    if (!_sixDataArr) {
        _sixDataArr = [[NSMutableArray alloc] init];
    }
    return _sixDataArr;
}

@end
