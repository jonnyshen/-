//
//  MYNotesTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYNotes.h"

@interface MYNotesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *classImage;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UILabel *notesTime;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (strong, nonatomic) MYNotes *obj;
-(void)setTableViewCellModel:(id)obj;


@end
