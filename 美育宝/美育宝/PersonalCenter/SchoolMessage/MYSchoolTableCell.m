//
//  MYSchoolTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSchoolTableCell.h"
#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation MYSchoolTableCell


//来自活动的数据
- (void)setTableViewCellModel:(ExerciseModel *)obj
{
    self.campName.text = obj.partyName;
//    self.teacher.text  = obj.teacher;
    self.detail.text   = [NSString stringWithFormat:@"活动参与人：%@",obj.partyDetail];
    
//    NSString *pieceString = [obj.partyTime substringWithRange:NSMakeRange(0, 12)];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    NSDate *date = [dateFormatter dateFromString:pieceString];
//    NSString *dateString = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];
    self.times.text = obj.partyTime;
    
    self.campImage.layer.cornerRadius = 8;
    self.campImage.layer.masksToBounds = YES;
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *image = [tools sendFileString:@"image.plist" andNumber:0];
    
    NSString *str = [obj.imageStr substringWithRange:NSMakeRange(0, 6)];
    NSString *temp = [NSString stringWithFormat:@"%@%@/%@",image,str,obj.imageStr];
    if (!temp) {
        self.campImage.image = [UIImage imageNamed:@"001.jpg"];
    } else {
       
        [self.campImage sd_setImageWithURL:[NSURL URLWithString:temp]];
        
    }
    
    
}

//来自学校公告的数据
- (void)setSchoolList:(MYSchool *)schoolList
{
    self.campName.text = schoolList.campTitle;
//        self.teacher.text  = schoolList.teacher;
    //    self.detail.text   = obj.detail;
    
    NSString *pieceString = [schoolList.times substringWithRange:NSMakeRange(0, 12)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormatter dateFromString:pieceString];
    NSString *dateString = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];
    self.times.text = dateString;
    
    self.campImage.layer.cornerRadius = 8;
    self.campImage.layer.masksToBounds = YES;
//    if (!schoolList.imagePath) {
//        self.campImage.image = [UIImage imageNamed:@"001.jpg"];
//    } else {
    
        [self.campImage sd_setImageWithURL:[NSURL URLWithString:schoolList.imagePath]];
        
//    }
}

@end
