//
//  RequestManager+ShopStore.m
//  Neighbours
//
//  Created by 王帅帅 on 13-12-25.
//  Copyright (c) 2013年 王帅帅. All rights reserved.
//

#import "RequestManager+ShopStore.h"

@implementation RequestManager (ShopStore)
- (void)requestWithParameter:(NSDictionary *)dictionary andRequestString:(NSString *)string;
{
    if (!paramsDictionary) {
        paramsDictionary = [[NSMutableDictionary alloc] init];
    }
    
    for (NSString *key in [dictionary allKeys]) {
        [paramsDictionary setObject:[dictionary objectForKey:key] forKey:key];
    }
    requestSting = [string copy];
    //开始异步请求
    [self startSynchronousRequestInfo];
}
@end
