//
//  ClassifiedCatalogueController.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "ClassifiedCatalogueController.h"
#import "AFNetworking.h"
#import "MYToolsModel.h"
#import "FormValidator.h"
#import "EducationStage.h"
#import "FirstInDefault.h"
#import "GradeEducation.h"
#import "SubjectModel.h"
#import "TeachingMaterial.h"
#import "UnitsModel.h"
#import "PeriodClass.h"

#import "ValuePickerView.h"
#import "SourceController.h"


@interface ClassifiedCatalogueController ()<UIGestureRecognizerDelegate,NSURLSessionDelegate>
{
    NSString *_imageDataString;
    NSString *_imageName;
    NSString *_kcms;
    NSString *_kch;
    NSString *bookEdition;
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

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@property (nonatomic, strong) ValuePickerView *pickerView;

@end

@implementation ClassifiedCatalogueController

- (instancetype)initWithImage:(NSString *)imageName andImageData:(NSString *)imageData classDecribe:(NSString *)descrbe
{
    self = [super init];
    if (self) {
        _imageName = imageName;
        _imageDataString   = imageData;
        _kcms = descrbe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    获取固定不联动的条件数据
    [self getFirstSightMessage];
//    获取联动数据
    [self teachingMaterial:nil];
    
    self.pickerView = [[ValuePickerView alloc] init];
    
    
    [self.oneBtn addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoBtn addTarget:self action:@selector(twoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn addTarget:self action:@selector(threeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fourBtn addTarget:self action:@selector(fourBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fiveBtn addTarget:self action:@selector(fiveBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sixBtn addTarget:self action:@selector(sixBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //上传
    [self.uploadButton addTarget:self action:@selector(uploadSourceProgressForTask) forControlEvents:UIControlEventTouchUpInside];
   
    //增加观察者，监视科目是否被点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectNameChange:) name:@"SUBJECT_CHANGE" object:nil];
    
}

- (void)subjectNameChange:(NSNotification *)notic
{
    _kch = notic.userInfo[@"subjectcode"];
}


#pragma mark - 资源上传所有button点击事件
- (void)oneBtnClick:(UIButton *)button
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
        [weakSelf.oneBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];
    
    
}

- (void)twoBtnAction:(UIButton *)button
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
        [weakSelf.twoBtn setTitle:stateArr[0] forState:UIControlStateNormal];
         [weakSelf teachingMaterial:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
    
}

- (void)threeBtnClickAction:(UIButton *)button
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
        [weakSelf.threeBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        
        NSString *subjectCode = [mutableDict objectForKey:stateArr[0]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:subjectCode,@"subjectcode", nil];
        NSNotification *notic = [NSNotification notificationWithName:@"SUBJECT_CHANGE" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notic];
    };
    
    [self.pickerView show];
    

    
   
}

- (void)fourBtnClickAction:(UIButton *)button
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
        [weakSelf.fourBtn setTitle:stateArr[0] forState:UIControlStateNormal];
         [weakSelf getUnits:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
    
    
}

- (void)fiveBtnClickAction:(UIButton *)button
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
        [weakSelf.fiveBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        [weakSelf periodClass:[mutableDict objectForKey:stateArr[0]]];
    };
    
    [self.pickerView show];
    
   
}

- (void)sixBtnClickAction:(UIButton *)button
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
        [weakSelf.sixBtn setTitle:stateArr[0] forState:UIControlStateNormal];
    };
    
    [self.pickerView show];

    
   
}

//获取动态数据的网络请求

- (void)getFirstSightMessage
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    NSString *relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    NSString *firstUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getuseractionrecord&ucode=%@",userCode];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:firstUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        for (NSDictionary *first in responseObject[@"data"]) {
            bookEdition = first[@"JCDM"];
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
            
            _kch = self.kemuID.firstObject;
            [self.threeBtn setTitle:self.threeDataArr.firstObject forState:UIControlStateNormal];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    

}

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
            
            // 获取到教材代码再执行获取单元目录
           
                [self getUnits:bookEdition];
            
            
            [self.fourBtn setTitle:[self.dictionary objectForKey:bookEdition] forState:UIControlStateNormal];
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

                [self periodClass:self.keshiID.firstObject];
           
            
            [self.fiveBtn setTitle:self.fiveDataArr.firstObject forState:UIControlStateNormal];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//
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
            [self.sixBtn setTitle:self.sixDataArr.firstObject forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 开始上传
- (void)uploadSourceProgressForTask
{
//    http://192.168.3.254:8082/GetDataToApp.aspx?action=savezy&usercode=R000000003&jyjd=004002&kch=150101&nj=1&zbh=131&zymc=161012175945434.jpg&filename=161012175945434.jpg&filesize=1613797&zyms=
    
    if (!_imageDataString) {
        [FormValidator showAlertWithStr:@"请选择上传的资源"];
        return;
    }
//    后台创建文件名
    [self createFieldName:_imageName];
    
}



//发起上传请求，创建文件夹
- (void)createFieldName:(NSString *)timeString
{
    
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    
    NSString *userPass = [tools sendFileString:@"LoginData.plist" andNumber:1];
    NSString *userName = [tools sendFileString:@"LoginData.plist" andNumber:6];
    
    
    NSString *create_File_Name = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><CreateFile xmlns=\"http://tempuri.org/\"><uName>%@</uName><uPwd>%@</uPwd><fileName>%@</fileName><type>%@</type></CreateFile></soap:Body></soap:Envelope>",userName, userPass,timeString, @"2"];
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
                [self uploadMessageToContextWithServiseSource];
                NSLog(@"%@",response);
            
            
            NSLog(@"----->%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
        }];
        [appendDataTask resume];
        
    });
    
    
    
    
}


- (void)uploadMessageToContextWithServiseSource
{
    //
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userCode = [tools sendFileString:@"LoginData.plist" andNumber:2];
    
    NSString *imgData_Length = [NSString stringWithFormat:@"%ld",_imageDataString.length];
    
    NSString *nj = nil;
    NSString *jyjd = nil;
    NSString *zbh = nil;
    
    for (FirstInDefault *paramter in self.defaultArray) {
        nj = paramter.nj;
        jyjd = paramter.jyjd;
        zbh = paramter.zbh;
    }
    __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *saveUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savezy&usercode=%@&jyjd=%@&kch=%@&nj=%@&zbh=%@&zymc=%@&filename=%@&filesize=%@&zyms=%@",userCode,jyjd,_kch,nj,zbh,_imageName,_imageName,imgData_Length,_kcms];
        
        NSString *codeUrl  = [saveUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:codeUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
                [FormValidator showAlertWithStr:@"保存成功"];
                
                //                SourceController *source = [[SourceController alloc] init];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            } else {
                [FormValidator showAlertWithStr:@"保存失败，请重试"];
            }
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        
        
    });

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
- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}


@end
