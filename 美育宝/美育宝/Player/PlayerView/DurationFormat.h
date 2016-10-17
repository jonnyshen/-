//
//  DurationFormat.h
//  LvDemos
//
//  Created by guangbo on 15/3/19.
//
//

#import <Foundation/Foundation.h>

@interface DurationFormat : NSObject

//传入一个NSTimeInterval类型，返回字符时间

+ (NSString *)durationTextForDuration:(NSTimeInterval)duration;

@end
