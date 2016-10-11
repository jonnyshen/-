//
//  SharePhotoCell.m
//  美育宝
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SharePhotoCell.h"
#import "MYToolsModel.h"
@implementation SharePhotoCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setTableViewCellModel:(ActivityImageModel *)obj
{
    //图片地址
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *image = [tools sendFileString:@"image.plist" andNumber:0];
    NSString *photoStr = nil;
    NSString *str      = nil;
    NSString *temp     = nil;
    NSMutableArray *pitureArray = [NSMutableArray array];
    for (int i = 0; i < obj.photoArr.count; i++) {
        photoStr = obj.photoArr[i];
        str = [photoStr substringWithRange:NSMakeRange(0, 6)];
        temp = [NSString stringWithFormat:@"%@%@/%@",image,str,photoStr];
        [pitureArray addObject:temp];
    }
    
    
    
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"https://www.baidu.com/img/bd_logo1.png",@"http://2c.zol-img.com.cn/product/88_800x600/180/ceFCdlFAKoN5w.jpg",@"http://2d.zol-img.com.cn/product/114/517/ce06vUoqw5Bgg.png",@"http://2c.zol-img.com.cn/product/80_800x600/334/cegDTJevDGJxE.png",@"http://2d.zol-img.com.cn/product/90/227/ceneimBJko79Y.jpg",@"http://2f.zol-img.com.cn/product/58/597/ce9T3GSaOyl3E.png",@"http://2e.zol-img.com.cn/product/80_800x600/312/ceNQAIkh4x2j6.png",@"http://photo.l99.com/bigger/32/1358684280697_kmh49z.gif",nil];
    
    NSMutableArray *array = pitureArray;
    
    //实例化布局对象
    _layout = [[SFLayout alloc] init];
    
    //图片数组
    _layout.arrayUrl = array;
    
    //传入图片所在的view
    _layout.pictureView = self.pictureView;
    [_layout setPictureArray];
    
    //设置布局,并且返回所占用的高度
    NSLog(@"%ld",(long)[_layout adjustPictureLocationWithSpace:20 pictureArray:array OriginX:10 originY:10]);
}

@end
