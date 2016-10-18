//
//  SourceUploadCell.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "SourceUploadCell.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"

@implementation SourceUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWorksData:(SourceData *)worksData
{
    
    if ([self pieceOfString:worksData.imgPath]) {
        [self.workImage sd_setImageWithURL:[NSURL URLWithString:[self pieceOfString:worksData.imgPath]] placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    //    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    //    [detailFormatter setLocale:[NSLocale currentLocale]];
    //    [detailFormatter setDateFormat:@"yyyyMMdd"];
    //    NSDate *date = [detailFormatter dateFromString:worksData.scsj];
    //
    //    NSString *time = [NSString stringWithFormat:@"%@", date];
    
    long long time=[worksData.scsj longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    
    NSString * timeStr =[df stringFromDate:d];
    
    self.timeLb.text = timeStr;
    self.titleLb.text = worksData.fjmc;
    
}

// 拼接图片路径
- (NSString *)pieceOfString:(NSString*)imageStr
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgurl = [tools sendFileString:@"WorksUpload.plist" andNumber:0];
    NSString *pictureStr = nil;
    if (imageStr.length > 0) {
        NSString *pieceStr = [imageStr substringWithRange:NSMakeRange(0, 6)];
        pictureStr = [NSString stringWithFormat:@"%@%@/%@",imgurl, pieceStr, imageStr];
    }
    return pictureStr;
}

@end
