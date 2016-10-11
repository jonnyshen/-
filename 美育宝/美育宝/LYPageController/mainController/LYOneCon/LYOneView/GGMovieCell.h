//
//  GGRecomGameCell.h
//  ThePeopleTV
//
//  Created by aoyolo on 16/3/30.
//  Copyright © 2016年 高广. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GGMovieCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *nickName;


-(void)setCellModel:(id)obj;
@end
