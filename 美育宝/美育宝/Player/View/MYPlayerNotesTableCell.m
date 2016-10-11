//
//  MYPlayerNotesTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYPlayerNotesTableCell.h"
#import "NotesModel.h"

@implementation MYPlayerNotesTableCell


- (void)setTableViewCellModel:(NotesModel *)obj
{
    self.notes.text = obj.notes;
    
    NSString *str = [obj.date substringWithRange:NSMakeRange(0, 8)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:str];
    self.times.text = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];
    
    
}

@end
