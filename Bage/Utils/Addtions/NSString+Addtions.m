//
//  NSString+Addtions.m
//  Bage
//
//  Created by Duger on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "NSString+Addtions.h"

@implementation NSString (Addtions)

+(NSString *)stringWithQuickUpdateSex:(NSInteger)sex andInterests:(NSInteger)interest
{
    NSString *tempStr = [NSString stringWithFormat:@"sex=%ld&interest=%ld",sex,interest];
    return tempStr;
}

+(NSString *)stringWithQuickUpdatePersonJid:(NSString *)personJid
                                        Sex:(NSInteger)sex
                                  topicType:(NSInteger)topicType
                                    topicId:(NSInteger)topicId
                                    runTime:(NSTimeInterval)runTime
                            partnerSpokenLV:(NSInteger)partnerSpokenLV
                                   language:(NSInteger)language
{
    

    NSString * request=[NSString stringWithFormat:@"personJid=%@",personJid];
    if( sex >= 0){
       request= [request stringByAppendingFormat:@"&sex=%ld",(NSInteger)sex];
    }
    if (topicType >= 0) {
        request = [request stringByAppendingFormat:@"&topicType=%ld",(NSInteger)topicType];
    }
    if (topicId > 0) {
        request = [request stringByAppendingFormat:@"&topicId=%ld",(NSInteger)topicId];
    }
    if (runTime) {
        request = [request stringByAppendingFormat:@"&runTime=%f",runTime];
    }
    if (partnerSpokenLV >= 0) {
        request = [request stringByAppendingFormat:@"&partnerSpokenLV=%ld",(NSInteger)partnerSpokenLV];
    }
    if (language >= 0) {
        request = [request stringByAppendingFormat:@"&language=%ld",(NSInteger)language];
    }
    
    return request;
                         
}

@end
