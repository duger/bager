//
//  RequestManager+ShopStore.h
//  Neighbours
//
//  Created by 王帅帅 on 13-12-25.
//  Copyright (c) 2013年 王帅帅. All rights reserved.
//

#import "RequestManager.h"

@interface RequestManager (ShopStore)
/**
 *用来给网络请求类封装参数和请求地址，
 *dictionary:要传送的参数字典
 *string:请求地址
 **/
- (void)requestWithParameter:(NSDictionary *)dictionary andRequestString:(NSString *)string;
@end
