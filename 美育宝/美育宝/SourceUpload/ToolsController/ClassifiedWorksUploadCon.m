//
//  ClassifiedWorksUploadCon.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
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


@interface ClassifiedWorksUploadCon ()

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

@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation ClassifiedWorksUploadCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getDefaultFirstSightMessage];
    [self getGroupNameAndID];
    
    self.pickerView = [[ValuePickerView alloc] init];
    
    [self.highViewBtn addTarget:self action:@selector(highViewLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.highOneBtn addTarget:self action:@selector(highoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.highTwoBtn addTarget:self action:@selector(hightwoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highThreeBtn addTarget:self action:@selector(highthreeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highFourBtn addTarget:self action:@selector(highfourBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highFiveBtn addTarget:self action:@selector(highfiveBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSixBtn addTarget:self action:@selector(highsixBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSevenBtn addTarget:self action:@selector(highSevenBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.highEightBtn addTarget:self action:@selector(highEightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.hightNineBtn addTarget:self action:@selector(highNineBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
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
    NSMutableArray *dataArr = [NSMutableArray array];
    for (EducationStage *data in self.stageArr) {
        [dataArr addObject:data.stageName];
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
    NSMutableArray *dataArr = [NSMutableArray array];
    for (GradeEducation *data in self.gradeArr) {
        [dataArr addObject:data.njbm];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"年级";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highTwoBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
    
}

- (void)highthreeBtnClickAction:(UIButton *)button
{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (SubjectModel *data in self.subjectArr) {
        [dataArr addObject:data.kcmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"科目";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highThreeBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
    
    
    
}

- (void)highfourBtnClickAction:(UIButton *)button
{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (TeachingMaterial *data in self.teachMaterialArr) {
        [dataArr addObject:data.jcmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"教材版本";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highFourBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
    
    
}

- (void)highfiveBtnClickAction:(UIButton *)button
{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (UnitsModel *data in self.unitsArr) {
        [dataArr addObject:data.bt];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"单元";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highFiveBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
    
}

- (void)highsixBtnClickAction:(UIButton *)button
{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (PeriodClass *data in self.periodArr) {
        [dataArr addObject:data.bt];
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
    for (ClassNumber *data in self.classNumArr) {
        [dataArr addObject:data.bjmc];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"班级";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highSevenBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
}
- (void)highEightBtnClickAction:(UIButton *)button
{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (GroupNameModel *data in self.highEightDataArr) {
        [dataArr addObject:data.name];
    }
    self.pickerView.dataSource = dataArr;
    self.pickerView.pickerTitle = @"小组";
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.highEightBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
}
- (void)highNineBtnClickAction:(UIButton *)button
{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (MembersModel *data in self.highNineDataArr) {
        [dataArr addObject:data.xm];
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


#pragma mark - 默认九个条件的上传

- (void)getDefaultFirstSightMessage
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    NSString *userName = [tools sendFileString:@"LoginData.plist" andNumber:0];
    
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
                [self.nianjiID addObject:grade[@"NJJD"]];
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
            
            [self teachingMaterial];
            [self.highThreeBtn setTitle:self.threeDataArr.firstObject forState:UIControlStateNormal];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    //获取班级小学一（1）班
    
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
            
            [self.highFourBtn setTitle:self.fourDataArr.firstObject forState:UIControlStateNormal];
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
            
            [self.highFiveBtn setTitle:self.fiveDataArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取课时
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
            [self.highSixBtn setTitle:self.sixDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取小组名
- (void)getGroupNameAndID
{
    NSString *units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getbjxiaozu&bjbh=gz01020101&jsgh=1015010"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.groupIDArr addObject:grade[@"Id"]];
                [self.groupNameArr addObject:grade[@"Name"]];
                GroupNameModel *groupName = [GroupNameModel dataWithDict:grade];
                [self.highEightDataArr addObject:groupName];
            }
            
            //获取到group后再执行获取课时
            
            [self getMemberName:nil];
            
            [self.highEightBtn setTitle:self.groupNameArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//获取小组成员
- (void)getMemberName:(NSString *)group
{
    NSString *units_URL = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getxiaozuxuesheng&xzbh=%@",@"702"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:units_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
        } else {
            for (NSDictionary *grade in responseObject[@"data"]) {
                [self.membersIDArr addObject:grade[@"StudentCode"]];
                [self.membersNameArr addObject:grade[@"XM"]];
                MembersModel *members = [MembersModel dataWithDict:grade];
                [self.highNineDataArr addObject:members];
            }
            
            
            
            [self.hightNineBtn setTitle:self.membersNameArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
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


@end
