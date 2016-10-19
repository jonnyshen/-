//
//  MYWorks.h
//  Page Demo

#import <Foundation/Foundation.h>

@interface MYWorks : NSObject

@property (nonatomic, strong) NSArray *imageStr;
@property (nonatomic, strong) NSString *timeLb;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *videoImage;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
