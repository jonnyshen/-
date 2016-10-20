//  WorksController.m
//  美育宝
#import "WorksController.h"
#import "WorksOneMode.h"
#import "WorksCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MYToolsModel.h"
#import "LrdSuperMenu.h"
#import "SkimController.h"
#import "ClassifiedWorksUploadCon.h"
#import "UploadWorksDisplayController.h"

#define TeacherTableViewFrame CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 40)
#define StudentTableViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)

@interface WorksController ()<UITableViewDelegate, UITableViewDataSource,LrdSuperMenuDelegate, LrdSuperMenuDataSource>
{
    NSString *imgurl;
    NSString *relationCode;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LrdSuperMenu *menu;

@property (nonatomic, strong) NSMutableArray *worksDataArr;
@property (nonatomic, strong) MYToolsModel *tools;

@property (strong, nonatomic) NSString *accountType;
@property (nonatomic, strong) NSMutableArray *classify;
@property (nonatomic, strong) NSMutableArray *classifyID;
@end

@implementation WorksController

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
        NSArray *arr = [self.tools getArrayFromPlistName:@"TeacherClass.plist" andNumber:1];
        [_classifyID addObjectsFromArray:arr];
    }
    return _classifyID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"作品上传";
    //    获取uitableview数据
    
    //    setup UITableView
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    self.accountType = [tools sendFileString:@"LoginData.plist" andNumber:5];
    relationCode = [tools sendFileString:@"LoginData.plist" andNumber:3];
    
    if ([self.accountType isEqualToString:@"2"]) {
        
        [self setUpTableView:StudentTableViewFrame];
        [self httpRequest:relationCode andClassIdent:self.classifyID.firstObject];
        
    } else {
        //   self.stuHeadView.hidden = YES;
        _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
        _menu.delegate = self;
        _menu.dataSource = self;
        [self.view addSubview:_menu];
        [_menu selectDeafultIndexPath];
        
        [self setUpTableView:TeacherTableViewFrame];
        
        [self.tableView addHeaderWithTarget:self action:@selector(headerAction)];
        [self.tableView headerBeginRefreshing];
        [self httpRequest:@"" andClassIdent:self.classifyID.firstObject];
    }
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemReply) target:self action:@selector(uploadTasksData)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    [self.tableView addHeaderWithTarget:self action:@selector(httpRequest:andClassIdent:)];
}

- (void)headerAction
{
    [self httpRequest:@"" andClassIdent:self.classifyID.firstObject];
    
}

- (void)setUpTableView:(CGRect)frame
{
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:(UITableViewStylePlain)];
    self.tableView = table;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WorksCell" bundle:nil] forCellReuseIdentifier:@"WorksCell"];
}

- (void)httpRequest:(NSString *)learnIdentifier andClassIdent:(NSString *)classId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *worksUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=getzplistbyday&pagesize=1000&pageindex=1&xh=%@&bh=%@&isgood=0",learnIdentifier,classId];
    
    [manager GET:worksUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        imgurl = responseObject[@"imgurl"];
        
        [self.worksDataArr removeAllObjects];
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        [tools saveToPlistWithPlistName:@"WorksUpload.plist" andData:imgurl];
        
        for (NSDictionary * params in responseObject[@"aaData"]) {
            NSMutableArray * arr = params[@"data"];
            for (NSDictionary * dict  in arr) {
                 WorkTwoMode * model = [WorkTwoMode dataWithDict:dict];
                
                [self.worksDataArr addObject:model];
            }
//            WorksOneMode *model = [WorksOneMode dataWithDict:params];
           
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        });
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.worksDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"WorksCell";
    WorksCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    WorkTwoMode *worksData = self.worksDataArr[indexPath.row];
    cell.worksData = worksData;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.worksDataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    WorksOneMode *model = self.worksDataArr[indexPath.row];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=deldx&dxid=%@",model.mxdm] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            //            [FormValidator showAlertWithStr:@"删除成功"];
        } else {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WorksOneMode *oneModel = self.worksDataArr[indexPath.row];
    NSString *photoStr = [self pieceOfString:oneModel.imgPath];
    
    NSMutableDictionary *dataArr = [NSMutableDictionary dictionary];
    [dataArr setValue:photoStr forKey:@"photostr"];
    [dataArr setValue:oneModel.fjmc forKey:@"fjmc"];
    [dataArr setValue:oneModel.mxdm forKey:@"mxdm"];
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    [tools saveToPlistWithPlistName:@"SkitData.plist" andDict:dataArr];
    
    SkimController *skit = [[SkimController alloc] init];
    
    [self.navigationController pushViewController:skit animated:YES];
}

//图片路径拼接
- (NSString *)pieceOfString:(NSString*)imageStr
{
    
    NSString *pictureStr = nil;
    if (imageStr.length > 0) {
        NSString *pieceStr = [imageStr substringWithRange:NSMakeRange(0, 6)];
        pictureStr = [NSString stringWithFormat:@"%@%@/%@",imgurl, pieceStr, imageStr];
    }
    return pictureStr;
}

//作品上传界面跳转
- (void)uploadTasksData
{
    
    UploadWorksDisplayController *sourceDisplay = [[UploadWorksDisplayController alloc] init];
    [self.navigationController pushViewController:sourceDisplay animated:YES];
    
    
}


#pragma mark - 顶部菜单栏
- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 1;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    return self.classify.count;
    
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (self.classify.count > 0) {
        return self.classify[indexPath.row];
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageNameForRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu imageForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForRowAtIndexPath:(LrdIndexPath *)indexPath {
    //    if (indexPath.column < 2) {
    //        return [@(arc4random()%1000) stringValue];
    //    }
    return nil;
}

- (NSString *)menu:(LrdSuperMenu *)menu detailTextForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}

- (NSInteger)menu:(LrdSuperMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    
    return 0;
}

- (NSString *)menu:(LrdSuperMenu *)menu titleForItemsInRowAtIndexPath:(LrdIndexPath *)indexPath {
    
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
            [self httpRequest:relationCode andClassIdent:self.classifyID[indexPath.row]];
        }
        
    }
}

- (NSMutableArray *)worksDataArr
{
    if (!_worksDataArr) {
        _worksDataArr = [[NSMutableArray alloc] init];
    }
    return _worksDataArr;
}

@end
