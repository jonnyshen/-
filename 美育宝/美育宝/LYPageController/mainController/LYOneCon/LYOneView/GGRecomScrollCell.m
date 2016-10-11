//
//  GGRecomScrollCell.m
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import "GGRecomScrollCell.h"

#import "GGRecomScrModel.h"
#import "FirstVCNewsModel.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCROLLERVIEW_URL @"http://192.168.3.254:8082/GetDataToApp.aspx?action=getadinfo&infocount=10"
#define kFIRSTVC_HEADERVIEW_CLICK @"FIRSTVC_HEADERVIEW_CLICK"

@interface GGRecomScrollCell()

@property (nonatomic, strong) NSMutableArray *newsArray;
@end

@implementation GGRecomScrollCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setCellModel:(NSString *)obj{
    if (obj) {
        
        NSArray *newsDataArr = [self getscrollViewNewsData];
        NSMutableArray *newsIDArr = [[NSMutableArray alloc] init];
        NSMutableArray *newsTitle = [[NSMutableArray alloc] init];
        NSInteger count = newsDataArr.count;
        
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i<count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,self.frame.size.height )];
        
        FirstVCNewsModel *news = newsDataArr[i];
        //         NSLog(@"%@---%@",news.newsID,news.title);
        [newsIDArr addObject:news.detailHtml];
        [newsTitle addObject:news.title];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, ScreenWidth, 20)];
        [imgView addSubview:label];

        label.text = [NSString stringWithFormat:@"%@",news.title];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];

        [imgView sd_setImageWithURL:[NSURL URLWithString:news.imagePath] placeholderImage:[UIImage imageNamed:@"loading"]];
        
        [viewsArray addObject:imgView];
    }
        
        
    self.mainScorllView = [[CycleScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height) animationDuration:2.0 Count:viewsArray.count];
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
//        __weak GGRecomScrollCell *weakSelf = self;
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
    
       
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic removeAllObjects];
            [parmDic setValue:newsTitle[pageIndex] forKey:@"newsTitle"];
        [parmDic setValue:newsIDArr[pageIndex] forKey:@"newsID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFIRSTVC_HEADERVIEW_CLICK object:nil userInfo:parmDic];
       
        
//        [weakSelf headerClick:newsIDArr[pageIndex]];
                    NSLog(@"点击了第%ld个",pageIndex);
    };
    
       [self addSubview:self.mainScorllView];
    }
}

- (void)headerClick:(NSString *)url
{
//    NSLog(@"====%@",url);
    if (self.TapHeaderActionBlock) {
        self.TapHeaderActionBlock(url);
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic removeAllObjects];
//    [parmDic setValue:newsTitle[pageIndex] forKey:@"newsTitle"];
    [parmDic setValue:url forKey:@"newsID"];
     [[NSNotificationCenter defaultCenter] postNotificationName:kFIRSTVC_HEADERVIEW_CLICK object:nil userInfo:parmDic];
    
    [self.delegate didSelectScrollAtIndex:url];
    
}



- (NSArray *)getscrollViewNewsData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:SCROLLERVIEW_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if (self.newsArray) {
                [self.newsArray removeAllObjects];
            }
            
            //            _imagePath = [responseObject objectForKey:@"imgurl"];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                FirstVCNewsModel *news = [FirstVCNewsModel newsDataWithDict:dict];
                
                [self.newsArray addObject:news];
            }
            
            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
    });
    
    return self.newsArray;
}


- (NSMutableArray *)newsArray
{
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}
@end
