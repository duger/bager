//
//  NSString+Addtions.h
//  Bage
//
//  Created by Duger on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addtions)
+(NSString *)stringWithQuickUpdatePersonJid:(NSString *)personJid
                                        Sex:(NSInteger)sex
                                  topicType:(NSInteger)topicType
                                    topicId:(NSInteger)topicId
                                    runTime:(NSTimeInterval)runTime
                            partnerSpokenLV:(NSInteger)partnerSpokenLV
                                   language:(NSInteger)language;

+(NSString *)stringWithQuickUpdateSex:(NSInteger)sex andInterests:(NSInteger)interest;
@end
