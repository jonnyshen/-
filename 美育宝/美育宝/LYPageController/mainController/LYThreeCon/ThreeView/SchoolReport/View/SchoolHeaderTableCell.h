//
//  SchoolHeaderTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolHeaderTableCell : UITableViewCell<UIScrollViewDelegate>
@property (strong, nonatomic) UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (strong, nonatomic)UIButton *backBtn;

@property (nonatomic, strong) NSMutableArray *marksArr;
@property (nonatomic, strong) NSMutableArray *codeArr;

-(void)setHeaderTableCellModel:(id)obj;
//-(void)setTableViewCellModel:(NSString * )obj;
@end
