//
//  CommentTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentCellModel.h"
#import "UIImageView+WebCache.h"
#import "HUStarView.h"
#import "AFNetworking.h"
#import "FormValidator.h"

@implementation CommentTableViewCell


- (void)setTableViewCellModel:(CommentCellModel *)obj
{
    self.wellReviewLB.text = obj.wellReview;
    self.middleReviewLB.text = obj.middleReview;
    self.badReviewLB.text = obj.badReview;
    self.abilityLB.text = obj.abilityReview;
    self.humorousLB.text = obj.humorous;
    
    self.headerImage.layer.cornerRadius = 8;
    self.headerImage.layer.masksToBounds = YES;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:obj.headImage]];
    
//    HUStarView *starRateView4 = [[HUStarView alloc] initWithFrame:CGRectMake(0, 0, self.starView.frame.size.width, self.starView.frame.size.height) numberOfStars:5 rateStyle:HalfStar isAnination:YES finish:^(CGFloat currentScore) {
//        NSLog(@"CommentStar----  %f",currentScore);
//    }];
    
    HUStarView *starRateView3 = [[HUStarView alloc] initWithFrame:CGRectMake(0, 0, self.starView.frame.size.width, self.starView.frame.size.height) finish:^(CGFloat currentScore) {
        NSLog(@"3----  %f",currentScore);
        commentRank = currentScore;
    }];
    
    [self.starView addSubview:starRateView3];
    
    [self.commentBtn addTarget:self action:@selector(saveCommentDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveCommentDetail
{
    [self getDataFilePath];
    NSString *saveJudgeUrl = [NSString stringWithFormat:@"http://192.168.3.254:8082/GetDataToApp.aspx?action=savepl&ucode=%@&upwd=%@&infoid=%@&pjdj=%f&pjnr=%@&type=1", _userCode, _PassWord, _classID, commentRank, self.commentText.text];
    NSString *text = [saveJudgeUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:text parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *success = [responseObject objectForKey:@"issuccess"];
        if ([success isEqualToString:@"true"]) {

            NSString *comment = self.commentText.text;
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:comment,@"comment" ,nil];
            NSNotification *notification = [[NSNotification alloc] initWithName:@"comment" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            self.commentText.text = @"";
            [self.commentText resignFirstResponder];
            [FormValidator showAlertWithStr:@"保存成功"];
        }

        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (void)getDataFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"PlayerID.plist"];
    NSString *login = [documentPath stringByAppendingPathComponent:@"LoginData.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:fileName];
        _classID = [path objectAtIndex:0];
        
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:login]) {
        NSArray *path = [[NSArray alloc] initWithContentsOfFile:login];
        _userCode = [path objectAtIndex:2];
        _PassWord = [path objectAtIndex:1];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    CommentTableViewCell *textcell = [[CommentTableViewCell alloc] init];
    [self.commentText resignFirstResponder];
}


@end
