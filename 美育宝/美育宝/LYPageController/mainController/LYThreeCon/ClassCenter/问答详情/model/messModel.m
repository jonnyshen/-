//
//  messModel.m
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "messModel.h"
#import "MYToolsModel.h"

@implementation messModel
-(instancetype)initWithModel:(NSDictionary *)mess{
    if (self=[super init]) {
        
        self.imageName = [self handleWithHeaderImage:mess[@"PersonImage"]];
        self.desc=mess[@"TW"];
        self.time= [self makeUpTimeString:mess[@"CJSJ"]];
        if ([mess[@"AccountType"] isEqualToString:@"老师"]) {
            self.person = NO;//老师评论在左边
        } else {
            self.person = YES;//学生评论在右边
        }
//        self.person=[mess[@"AccountType"] boolValue]; //转为Bool类型
    }
    return self;
}
+(instancetype)messModel:(NSDictionary *)mess{
    return [[self alloc]initWithModel:mess];
}

- (NSString *)handleWithHeaderImage:(NSString *)imageStr
{
    if ([imageStr isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *linkImageStr = [tools sendFileString:@"QuestionAndAnswer.plist" andNumber:0];
//    NSString *pieceImageStr = [imageStr substringWithRange:NSMakeRange(0, 6)];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",linkImageStr,imageStr];
//    NSLog(@"......%@",imageStr);
    return imageUrl;
}

- (NSString *)makeUpTimeString:(NSString *)timeStr
{
    NSString *str = [timeStr substringWithRange:NSMakeRange(0, 12)];
    //NSLog(@"......%@",str);
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
    NSString *timetext = [NSString stringWithFormat:@"%@", date];
    
    NSString *cutTime = [timetext substringWithRange:NSMakeRange(0, 16)];
    return cutTime;
}

@end
