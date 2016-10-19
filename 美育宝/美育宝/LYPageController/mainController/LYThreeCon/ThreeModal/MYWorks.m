//  MYWorks.m
//  Page Demo
#import "MYWorks.h"
#import "MYWorkImage.h"

@implementation MYWorks

- (instancetype)initWithDict:(NSDictionary *)dict
{
    MYWorks *works = [[MYWorks alloc] init];
    
    works.timeLb = dict[@"dayName"];
    
    NSArray *imageArr = dict[@"data"];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary * params in imageArr) {
        MYWorkImage *image = [MYWorkImage workModelWithDictionary:params];
        [arr addObject:image];
        
        works.imageStr = params[@""];
        
    }
    works.imageStr = arr;
    
    return works;
}


+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}

@end
