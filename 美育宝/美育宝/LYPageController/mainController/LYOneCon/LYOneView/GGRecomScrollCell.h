//
//  GGRecomScrollCell.h
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@protocol GGRecomScrollCellDelegate <NSObject>

-(void)didSelectScrollAtIndex:(NSString *)index;

@end

@interface GGRecomScrollCell : UICollectionViewCell

@property (nonatomic , retain)CycleScrollView *mainScorllView;

@property (nonatomic , copy) void (^TapHeaderActionBlock)(NSString* pageIndexUrl);

@property (nonatomic,assign) id<GGRecomScrollCellDelegate>delegate;

-(void)setCellModel:(NSString *)obj;
@end
