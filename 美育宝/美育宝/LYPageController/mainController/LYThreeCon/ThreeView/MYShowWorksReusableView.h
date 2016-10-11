//
//  MYShowWorksReusableView.h
//  美育宝
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYWorks.h"

@interface MYShowWorksReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;

- (void)setResuableViewCellModel:(MYWorks *)works;
/*


 */
@end
