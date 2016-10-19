//  MYToolsModel.m
//  Created by apple on 16/5/20.
#import "MYToolsModel.h"

#define kFILE_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

@implementation MYToolsModel

- (NSString *)sendFileString:(NSString *)str andNumber:(NSInteger)number
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:str];
    
    NSString *userCode = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        userCode = [path objectAtIndex:number];
        
    }
    return userCode;
}

- (NSArray *)getDataArrayFromPlist:(NSString *)str
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:str];
    
    NSArray *dataArr = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        dataArr = [[NSArray alloc] initWithContentsOfFile:fileName];
    }
    return dataArr;
}

- (NSDictionary *)getDictArrayFromPlist:(NSString *)str
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:str];
    
    NSDictionary *dataArr = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        dataArr = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    }
    
    return dataArr;
}

- (NSMutableArray *)getArrayFromPlistName:(NSString *)str andNumber:(NSInteger)number
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:str];
    
    NSMutableArray *userCode = [NSMutableArray array];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        userCode = [path objectAtIndex:number];
        
    }
    return userCode;
}


- (void)saveDataToPlistWithPlistName:(NSString *)fileName andData:(NSArray *)data
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    
    NSString *filePa = [documentPath stringByAppendingPathComponent:fileName];

    [data writeToFile:filePa atomically:YES];

}

//   保存 路经（图片。。。）
- (void)saveToPlistWithPlistName:(NSString *)fileName andData:(NSString *)data
{
    if (!data) {
        return;
    }
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSLog(@"---%@",documentPath);
    NSString *filePa = [documentPath stringByAppendingPathComponent:fileName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:data];
    [array writeToFile:filePa atomically:YES];
}

- (void)saveToPlistWithPlistName:(NSString *)fileName fileData:(NSData *)data andOrder:(NSInteger)order
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:order];
    
    NSString *filePa = [documentPath stringByAppendingPathComponent:fileName];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:data];
    [array writeToFile:filePa atomically:YES];
}

- (void)saveToPlistWithPlistName:(NSString *)fileName andDict:(NSDictionary *)data
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    
    NSString *filePa = [documentPath stringByAppendingPathComponent:fileName];
    
    [data writeToFile:filePa atomically:YES];
}


@end
