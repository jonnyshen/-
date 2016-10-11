//
//  MYNotesTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYNotesTableCell.h"

#import "UIImageView+WebCache.h"

@implementation MYNotesTableCell

- (void)setTableViewCellModel:(MYNotes *)obj
{
    NSLog(@"---notes---%@%@",obj.className,obj.notes);
    self.classImage.layer.cornerRadius = 8;
    self.classImage.layer.masksToBounds = YES;
    //self.classImage.image = [UIImage imageNamed:@"001.png"];
    [self.classImage sd_setImageWithURL:[NSURL URLWithString:@"http://192.168.1.254:8000/UploadFile/hd/160405/160405134632385.jpg"]];
    self.className.text = obj.className;
    self.notes.text = obj.notes;
    
    NSString *str = [obj.times substringWithRange:NSMakeRange(0, 12)];
    
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
    self.notesTime.text = [NSString stringWithFormat:@"%@", date];
    
}

- (void)setObj:(MYNotes *)obj
{
    self.classImage.layer.cornerRadius = 8;
    self.classImage.layer.masksToBounds = YES;
    //self.classImage.image = [UIImage imageNamed:@"001.png"];
    [self.classImage sd_setImageWithURL:[NSURL URLWithString:@"http://192.168.1.254:8000/UploadFile/hd/160405/160405134632385.jpg"]];
    self.className.text = obj.className;
    self.notes.text = obj.notes;
//    if () {
//        NSString *str = [obj.times substringWithRange:NSMakeRange(0, 12)];
//        
//        NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
//        [detailFormatter setLocale:[NSLocale currentLocale]];
//        [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
//        NSDate *date = [detailFormatter dateFromString:str];
//        self.notesTime.text = [NSString stringWithFormat:@"%@", date];
//    } else {
//        
//    }
    
}

@end
