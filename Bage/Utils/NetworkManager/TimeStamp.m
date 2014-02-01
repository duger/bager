//
//  TimeStamp.m
//  DBuyer
//
//  Created by liuxiaodan on 13-10-15.
//  Copyright (c) 2013年 liuxiaodan. All rights reserved.
//

#import "TimeStamp.h"

@implementation TimeStamp
+(NSString *)timeStamp{
    NSDate *datenow = [NSDate date];
   return [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
}
@end
