//
//  MYCourseTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYCourseTableCell.h"

#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"

@implementation MYCourseTableCell

- (void)setTableViewCellModel:(MYCourse *)obj
{
    if ([obj.className isKindOfClass:[NSNull class]]) {
        self.course.text = @" ";
    } else {
        self.course.text = obj.className;
    }
    
    if ([obj.teacher isKindOfClass:[NSNull class]]) {
        self.teacher.text = @"";
    } else {
        self.teacher.text = obj.teacher;
    }
    
    self.number.text = [NSString stringWithFormat:@"%@/%@",obj.editClass, obj.sumClass];
  
    

    self.ClassImage.layer.cornerRadius = 8;
    self.ClassImage.layer.masksToBounds = YES;
    
    if ([obj.imageStr isKindOfClass:[NSNull class]]) {
        self.ClassImage.image = [UIImage imageNamed:@"004.jpg"];
    } else {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *image = [tools sendFileString:@"Course.plist" andNumber:0];
        
        NSString *str = [obj.imageStr substringWithRange:NSMakeRange(0, 6)];
        NSString *temp = [NSString stringWithFormat:@"%@%@/%@",image,str,obj.imageStr];
        NSLog(@"------temp----%@",temp);
        
        [self.ClassImage sd_setImageWithURL:[NSURL URLWithString:temp]];
    }
    
    
}

@end
