//
//  Require.h
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Require : NSObject

@property (nonatomic,copy) NSString *personJid;
@property (nonatomic, retain) NSMutableArray *propertyList;

//获得所以属性的名字和值
- (NSMutableArray *)propertyList;

//创建Post请求
- (NSString *)createPostRequire;
@end
