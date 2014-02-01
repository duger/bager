//
//  DataModel.m
//  Graph
//
//  Created by Lori on 13-12-25.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
- (id)initWithDataWithDate:(NSString *)date
                       sum:(NSString *)sum
                    value1:(NSString *)value1
                    value2:(NSString *)value2
                    value3:(NSString *)value3
{
    self = [super init];
    if (self == nil) {
        self.date = date;
        self.sum = sum;
        self.value1 = value1;
        self.value2 = value2;
        self.value3 = value3;
    }
    return self;
}
- (void)dealloc
{
    [_date release];
    [_sum release];
    [_value1 release];
    [_value2 release];
    [_value3 release];
    [super dealloc];
}

@end
