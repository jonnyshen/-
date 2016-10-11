//
//  GGListClassCell.h
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GGListClassCell : UICollectionViewCell

@property (nonatomic, copy)NSArray *images;
@property (nonatomic, copy)NSArray *titles;
-(void)setCellModel:(NSString *)obj;

@end
