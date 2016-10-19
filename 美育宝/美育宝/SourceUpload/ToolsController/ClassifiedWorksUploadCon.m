//
//  ClassifiedWorksUploadCon.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "ClassifiedWorksUploadCon.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"
#import "FirstInDefault.h"
#import "EducationStage.h"
#import "GradeEducation.h"
#import "SubjectModel.h"
#import "TeachingMaterial.h"
#import "UnitsModel.h"
#import "PeriodClass.h"
#import "ClassNumber.h"
#import "GroupNameModel.h"
#import "MembersModel.h"
#import "ValuePickerView.h"
#import "FormValidator.h"

@interface ClassifiedWorksUploadCon ()<UIGestureRecognizerDelegate,NSURLSessionDelegate>

{
    NSString *_imageDataString;//图片，视频data base64转为字符串
    NSString *_imageName;//图片名
    NSString *_kch;//课程号
    NSString *_bjbh;//班级编号
    NSString *bookEdition;//
    
    NSString *sourceDesribe;//课程描述
    
}

@property (weak, nonatomic) IBOutlet UIView *lowUploadView;
@property (weak, nonatomic) IBOutlet UIButton *lowOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *lowTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *lowUploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *highViewBtn;


@property (nonatomic, strong) NSMutableArray *defaultArray;
@property (nonatomic, strong) NSMutableArray *stageArr;

@property (nonatomic, strong) NSMutableArray *gradeArr;

@property (nonatomic, strong) NSMutableArray *subjectArr;
@property (nonatomic, strong) NSMutableArray *nianjiID;
@property (nonatomic, strong) NSMutableArray *kemuID;
@property (nonatomic, strong) NSMutableArray *danyuanID;
@property (nonatomic, strong) NSMutableArray *keshiID;
@property (nonatomic, strong) NSMutableArray *classNumArr;
@property (nonatomic, strong) NSMutableArray *classIDArr;
@property (nonatomic, strong) NSMutableArray *classidentyArr;

@property (nonatomic, strong) NSMutableArray *groupIDArr;
@property (nonatomic, strong) NSMutableArray *groupNameArr;

@property (nonatomic, strong) NSMutableArray *membersIDArr;
@property (nonatomic, strong) NSMutableArray *membersNameArr;

@property (nonatomic, strong) NSMutableArray *teachMaterialArr;
@property (nonatomic, strong) NSMutableArray *unitsArr;
@property (nonatomic, strong) NSMutableArray *periodArr;


@property (nonatomic, strong) NSMutableArray *oneDataArr;
@property (nonatomic, strong) NSMutableArray *twoDataArr;
@property (nonatomic, strong) NSMutableArray *threeDataArr;
@property (nonatomic, strong) NSMutableArray *fourDataArr;
@property (nonatomic, strong) NSMutableArray *fiveDataArr;
@property (nonatomic, strong) NSMutableArray *sixDataArr;
@property (nonatomic, strong) NSMutableArray *highEightDataArr;
@property (nonatomic, strong) NSMutableArray *highNineDataArr;
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation ClassifiedWorksUploadCon

- (instancetype)initWithImageData:(NSString *)imageDataString classDecribe:(NSString *)descrbe
{
    self = [super init];
    if (self) {
        sourceDesribe = descrbe;
        _imageDataString = imageDataString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDefaultFirstSightMessage];
    [self getGroupNameAndID:nil];
    [self teachingMaterial:nil];
    
    self.pickerView = [[ValuePickerView alloc] init];
    
    /**
     刚进入页面默认的两个条件上传button action
     */
    [self.lowOneBtn addTarget:self action:@selector(highEightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lowTwoBtn addTarget:self action:@selector(highNineBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.highViewBtn addTarget:self action:@selector(highViewLoading) forControlEvents:UIControlEventTouchUpInside];
    /*
     高级设置条件上传的九个button action
     */
    
    [self.highOneBtn addTarget:self action:@selector(highoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.highTwoBtn addTarget:self action:@selector(hightwoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highThreeBtn addTarget:self action:@selector(highthreeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highFourBtn addTarget:self action:@selector(highfourBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highFiveBtn addTarget:self action:@selector(highfiveBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSixBtn addTarget:self action:@selector(highsixBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSevenBtn addTarget:self action:@selector(highSevenBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highEightBtn addTarget:self action:@selector(highEightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.hightNineBtn addTarget:self action:@selector(highNineBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lowUploadBtn addTarget:self action:@selector(worksUploadGoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.highUploadBtn addTarget:self action:@selector(worksUploadGoAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //增加观察者，监视科目是否被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectNameChange:) name:@"SUBJECT_CHANGE" object:nil];
    
}

- (void)subjectNameChange:(NSNotification *)notic
{
    _kch = notic.userInfo[@"subjectcode"];
}


#pragma mark - 默认两个条件的上传

- (void)highViewLoading
{
    self.highView.hidden = NO;
    self.lowUploadView.hidden = YES;
}

#pragma mark - highViewButtonAction
- (void)highoneBtnClick:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    // 阶段名称可变数组 
    NSMutableArray *dataArr = [NSMutableArray array];
    //EducationStage   教育阶段(年级)
    for (EducationStage *data in self.stageArr) {
    //data.stageName   阶段名称
        [dataArr addObject:data.stageName];
        [mutableDict setValue:data.stageIdentifier forKey:data.stageName];
    }
    
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"教育阶段";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highOneBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        
    };
    
    [self.pickerView show];
    
    
}

- (void)hightwoBtnAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (GradeEducation *data in self.gradeArr) {
        [dataArr addObject:data.njbm];
        [mutableDict setValue:data.bh forKey:data.njbm];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"年级";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highTwoBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        [weakSelf teachingMaterial:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
    
}

- (void)highthreeBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
   
    NSMutableArray *dataArr = [NSMutableArray array];
    for (SubjectModel *data in self.subjectArr) {
        [dataArr addObject:data.kcmc];
         [mutableDict setValue:data.kch forKey:data.kcmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"科目";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highThreeBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        
        NSString *subjectCode = [mutableDict objectForKey:stateArr[0]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subjectCode,@"subjectcode", nil];
        NSNotification *notic = [NSNotification notificationWithName:@"SUBJECT_CHANGE" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notic];
    };
    
    [self.pickerView show];
    
    
    
    
}

- (void)highfourBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (TeachingMaterial *data in self.teachMaterialArr) {
        [dataArr addObject:data.jcmc];
        [mutableDict setValue:data.jcdm forKey:data.jcmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"教材版本";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highFourBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        [weakSelf getUnits:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
    
    
}

- (void)highfiveBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (UnitsModel *data in self.unitsArr) {
        [dataArr addObject:data.bt];
        [mutableDict setValue:data.zbh forKey:data.bt];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"单元";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highFiveBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        [weakSelf periodClass:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
    
}

- (void)highsixBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (PeriodClass *data in self.periodArr) {
        [dataArr addObject:data.bt];
        [mutableDict setValue:data.zbh forKey:data.bt];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"课时";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highSixBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        
    };
    
    [self.pickerView show];
    
    
    
}

- (void)highSevenBtnClickAction:(UIButton *)button
{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    for (ClassNumber *data in self.classNumArr) {
        [dataArr addObject:data.bjmc];
        [mutableDict setValue:data.bjh forKey:data.bjmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"班级";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highSevenBtn setTitle:stateArr[0] forState:UIControlStateNormal];
//        NSLog(@"---->>%@",[mutableDict objectForKey:stateArr[0]]);
        [weakSelf getGroupNameAndID:[mutableDict objectForKey:stateArr[0]]];
        
        _bjbh = [mutableDict objectForKey:stateArr[0]];
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subjectCode,@"bjbh", nil];
//        NSNotification *notic = [NSNotification notificationWithName:@"BAN_JI_HAO" object:nil userInfo:dict];
//        [[NSNotificationCenter defaultCenter] postNotification:notic];
    };
    
    [self.pickerView show];
    
}
- (void)highEightBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (GroupNameModel *data in self.highEightDataArr) {
        [dataArr addObject:data.name];
        [mutableDict setValue:data.identifier forKey:data.name];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"小组";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highEightBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        [weakSelf getMemberName:[mutableDict objectForKey:dataArr[0]]];
    };
    
    [self.pickerView show];
    
}
- (void)highNineBtnClickAction:(UIButton *)button
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (MembersModel *data in self.highNineDataArr) {
        [dataArr addObject:data.xm];
        [mutableDict setValue:data.StudentCode forKey:data.xm];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"成员";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.hightNineBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
}


#pragma mark - 默认九个条件的上传，不联动。。。

- (void)getDefaultFirstSightMessage
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    NSString *userName = [tools sendFileString:@"LoginData.plist" andNumber:0];
    
    NSString *firstUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getuseractionrecord&ucode=%@",userCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:firstUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            
        } else {
            for (NSDictionary *first in responseObject[@"data"]) {
                bookEdition = first[@"JCDM"];
                _bjbh       = first[@"BH"];
                FirstInDefault *defaultIN = [FirstInDefault dataWithDict:first];
                [self.defaultArray addObject:defaultIN];
                
            }
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
            [self.highOneBtn setTitle:self.oneDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    //获取年级
    
    NSString *grade_Url = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbasedatanj&jdid=004002&teachercode=%@",relationCode];
    
    [manager GET:grade_Url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.nianjiID addObject:grade[@"NJ"]];
                [self.twoDataArr addObject:grade[@"NJBM"]];
                GradeEducation *stage = [GradeEducation dataWithDict:grade];
                [self.gradeArr addObject:stage];
            }
            
            [self.highTwoBtn setTitle:self.twoDataArr.firstObject forState:UIControlStateNormal];
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
            [self.highThreeBtn setTitle:self.threeDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
//    获取班级信息
    NSString *classNumberURL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getmyclass&logincode=%@",userName];
    
    [manager GET:classNumberURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.classIDArr addObject:grade[@"BJH"]];
                [self.classidentyArr addObject:grade[@"BJMC"]];
                ClassNumber *stage = [ClassNumber dataWithDict:grade];
                [self.classNumArr addObject:stage];
            }
            
            
            [self.highSevenBtn setTitle:self.classidentyArr.firstObject forState:UIControlStateNormal];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
    
}
#pragma mark - 默认九个条件的上传，带有联动。。。
- (void)teachingMaterial:(NSString *)grade
{
    //获取教材上下册
    NSString *teaching_Material_URL = nil;
    if (grade == nil) {
        teaching_Material_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getjclist&nj=1&km=150101"];
    } else {
        teaching_Material_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getjclist&nj=%@&km=150101",grade];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:teaching_Material_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self.danyuanID removeAllObjects];
        [self.fourDataArr removeAllObjects];
        [self.teachMaterialArr removeAllObjects];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                 [self.dictionary setValue:grade[@"JCMC"] forKey:grade[@"JCDM"]];
                [self.danyuanID addObject:grade[@"JCDM"]];
                [self.fourDataArr addObject:grade[@"JCMC"]];
                TeachingMaterial *stage = [TeachingMaterial dataWithDict:grade];
                [self.teachMaterialArr addObject:stage];
            }
            
            //            获取到教材代码再执行获取单元目录
            if (grade == nil) {
                [self.highFourBtn setTitle:[self.dictionary objectForKey:bookEdition] forState:UIControlStateNormal];
                 [self getUnits:bookEdition];
                
            } else {
                [self.highFourBtn setTitle:[self.dictionary objectForKey:self.danyuanID.firstObject] forState:UIControlStateNormal];
               [self getUnits:self.danyuanID.firstObject];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取单元目录
- (void)getUnits:(NSString *)material
{
    NSString *units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcdyml&jcdm=%@",material];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self.keshiID removeAllObjects];
        [self.fiveDataArr removeAllObjects];
        [self.unitsArr removeAllObjects];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.keshiID addObject:grade[@"ZBH"]];
                [self.fiveDataArr addObject:grade[@"BT"]];
                UnitsModel *stage = [UnitsModel dataWithDict:grade];
                [self.unitsArr addObject:stage];
            }
            
            //获取到zbh后再执行获取课时
            if (material == nil) {
                [self periodClass:nil];
            } else {
                [self periodClass:self.keshiID.firstObject];
            }
            
            
            [self.highFiveBtn setTitle:self.fiveDataArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取课时
- (void)periodClass:(NSString *)units
{
    NSString *period_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getkcksml&zbh=%@",units];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:period_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self.sixDataArr removeAllObjects];
        [self.periodArr removeAllObjects];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.sixDataArr addObject:grade[@"BT"]];
                PeriodClass *stage = [PeriodClass dataWithDict:grade];
                [self.periodArr addObject:stage];
            }
            [self.highSixBtn setTitle:self.sixDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}



//获取小组名
- (void)getGroupNameAndID:(NSString *)bjbh
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    NSString *units_URL = nil;
    if (bjbh == nil) {
        units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjxiaozu&bjbh=gz01020101&jsgh=1015010"];
    } else {
        units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjxiaozu&bjbh=%@&jsgh=%@",bjbh,relationCode];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self.groupIDArr removeAllObjects];
        [self.groupNameArr removeAllObjects];
        [self.highEightDataArr removeAllObjects];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.groupIDArr addObject:grade[@"Id"]];
                [self.groupNameArr addObject:grade[@"Name"]];
                GroupNameModel *groupName = [GroupNameModel dataWithDict:grade];
                [self.highEightDataArr addObject:groupName];
            }
            
            //获取到group后再执行获取课时
            if (!bjbh) {
                [self getMemberName:nil];
            } else {
                [self getMemberName:self.groupIDArr.firstObject];
            }
            
            [self.highEightBtn setTitle:self.groupNameArr.firstObject forState:UIControlStateNormal];
            [self.lowOneBtn setTitle:self.groupNameArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取小组成员
- (void)getMemberName:(NSString *)group
{
    NSString *units_URL = nil;
    if (group == nil) {
       units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxiaozuxuesheng&xzbh=%@",@"702"];
    } else {
        units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxiaozuxuesheng&xzbh=%@",group];
    }
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [self.membersIDArr removeAllObjects];
        [self.membersNameArr removeAllObjects];
        [self.highNineDataArr removeAllObjects];
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.membersIDArr addObject:grade[@"StudentCode"]];
                [self.membersNameArr addObject:grade[@"XM"]];
                MembersModel *members = [MembersModel dataWithDict:grade];
                [self.highNineDataArr addObject:members];
            }
            
            
            [self.lowTwoBtn setTitle:self.membersNameArr.firstObject forState:UIControlStateNormal];
            [self.hightNineBtn setTitle:self.membersNameArr.firstObject forState:UIControlStateNormal];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 上传数据
- (void)worksUploadGoAction
{
    
    if (!_imageDataString) {
        [FormValidator showAlertWithStr:@"请选择上传的资源"];
        return;
    }
    
    //获取系统时间戳
    NSDate *dateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    _imageName = [[NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:dateTime]] substringFromIndex:2];
    

    
//    在服务器创建上传资源的文件名
    [self createFieldName:_imageName];
    
    //
   
    
    
}


//发起上传请求，创建文件夹
- (void)createFieldName:(NSString *)timeString
{
    
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    
    NSString *userPass = [tools sendFileString:@"LoginData.plist" andNumber:1];
    NSString *userName = [tools sendFileString:@"LoginData.plist" andNumber:6];
    
    
    NSString *create_File_Name = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><CreateFile xmlns=\"http://tempuri.org/\"><uName>%@</uName><uPwd>%@</uPwd><fileName>%@</fileName><type>%@</type></CreateFile></soap:Body></soap:Envelope>",userName, userPass,timeString, @"2"];
    //    NSLog(@"%@",create_File_Name);
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    NSString *file_Name_Length = [NSString stringWithFormat:@"%ld",create_File_Name.length];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file_Name_Url]];
    [request addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"content-type"];
    [request addValue:@"http://tempuri.org/CreateFile" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:file_Name_Length forHTTPHeaderField:@"content-length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[create_File_Name dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"======>>%@",datastr);
        [self imageName:timeString];
    }];
    
    [dataTask resume];
}


//上传数据
- (void)imageName:(NSString *)name
{
    
    NSString *file_Name_Url = @"http://192.168.3.254:8082/FileUp.asmx";
    
    
    NSString *appendingStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AppendToFile xmlns=\"http://tempuri.org/\"><fileName>%@</fileName><buffer>%@</buffer><type>%@</type></AppendToFile></soap:Body></soap:Envelope>",name,_imageDataString,@"2"];
    
    NSString *appending_File_Length = [NSString stringWithFormat:@"%ld",appendingStr.length];
    
    
    NSMutableURLRequest *appendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file_Name_Url]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [appendRequest addValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"content-type"];
    [appendRequest addValue:appending_File_Length forHTTPHeaderField:@"content-length"];
    [appendRequest addValue:@"http://tempuri.org/AppendToFile" forHTTPHeaderField:@"SOAPAction"];
    [appendRequest setHTTPMethod:@"POST"];
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURLSessionUploadTask *appendDataTask = [manager uploadTaskWithRequest:appendRequest fromData:[appendingStr dataUsingEncoding:NSUTF8StringEncoding] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error)
                NSLog(@"Error: %@", error);
            else
                [self uploadMessageContextWithSource];
                NSLog(@"%@",response);
            
            
            NSLog(@"----->%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
        }];
        [appendDataTask resume];
        
    });
    
    
    
    
}


- (void)uploadMessageContextWithSource
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    NSString *imgData_Length = [NSString stringWithFormat:@"%ld",_imageDataString.length];
    
    NSString *nj = nil;
    NSString *jyjd = nil;
    NSString *zbh = nil;
    
    for (FirstInDefault *paramter in self.defaultArray) {
        nj = paramter.nj;
        jyjd = paramter.jyjd;
        zbh = paramter.zbh;
        _kch = paramter.km;
    }
    __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        //    http://192.168.3.254:8082/GetDataToApp.aspx?action=savedxzp&xscode=R000000003&relationcode=401061992121470000&jyjd=004002&nj=1&kch=150101&zbh=131&bjbh=gz01020101&zpmc=161012180105791.jpg&wjmc=161012180108252.jpg&wjdx=1358730&zyms=&wjlx=.jpg&dxid=0&zply=3
        
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savedxzp&xscode=%@&relationcode=%@&jyjd=%@&nj=%@&kch=%@&zbh=%@&bjbh=%@&zpmc=%@&wjmc=%@&wjdx=%@&zyms=%@&wjlx=.png&dxid=0&zply=3",userCode,relationCode,jyjd,nj,_kch,zbh,_bjbh,_imageName,_imageName,imgData_Length,sourceDesribe];
        
        NSString *codeUrl  = [saveUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:codeUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                [FormValidator showAlertWithStr:@"上传成功！"];
            } else {
                
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
    });

}

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
- (NSMutableArray *)classIDArr
{
    if (!_classIDArr) {
        _classIDArr = [[NSMutableArray alloc] init];
    }
    return _classIDArr;
}
- (NSMutableArray *)classidentyArr
{
    if (!_classidentyArr) {
        _classidentyArr = [[NSMutableArray alloc] init];
    }
    return _classidentyArr;
}
- (NSMutableArray *)classNumArr
{
    if (!_classNumArr) {
        _classNumArr = [[NSMutableArray alloc] init];
    }
    return _classNumArr;
}
- (NSMutableArray *)groupIDArr
{
    if (!_groupIDArr) {
        _groupIDArr = [[NSMutableArray alloc] init];
    }
    return _groupIDArr;
}
- (NSMutableArray *)groupNameArr
{
    if (!_groupNameArr) {
        _groupNameArr = [[NSMutableArray alloc] init];
    }
    return _groupNameArr;
}
- (NSMutableArray *)membersIDArr
{
    if (!_membersIDArr) {
        _membersIDArr = [[NSMutableArray alloc] init];
    }
    return _membersIDArr;
}
- (NSMutableArray *)membersNameArr
{
    if (!_membersNameArr) {
        _membersNameArr = [[NSMutableArray alloc] init];
    }
    return _membersNameArr;
}
- (NSMutableArray *)highEightDataArr
{
    if (!_highEightDataArr) {
        _highEightDataArr = [[NSMutableArray alloc] init];
    }
    return _highEightDataArr;
}
- (NSMutableArray *)highNineDataArr
{
    if (!_highNineDataArr) {
        _highNineDataArr = [[NSMutableArray alloc] init];
    }
    return _highNineDataArr;
}
- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}

@end
